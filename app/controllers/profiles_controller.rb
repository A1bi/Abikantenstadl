require "zip"

class ProfilesController < ApplicationController
  @@lock_time = Time.local(2014, 2, 1, 3)
  
  restrict_access_to_admins only: [:index]
  
  before_filter :find_fields, only: [:edit]
  before_filter :find_user, only: [:edit, :update]
  
  def index
    @fields = ProfileField.all
    @users = User.ordered_by_name.student
    respond_to do |format|
      format.html
      format.zip do
        path = File.join(Rails.public_path, "system", "archives")
        FileUtils.mkdir_p(path)
        path = File.join(path, "profiles.zip")
        
        if !File.exists?(path)
          FileUtils.rm(path) if File.exists?(path)
    
          zip = Zip::File.open(path, Zip::File::CREATE)
          
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.people do
              @users.each do |user|
                xml.person do
                  xml.firstname user.first_name
                  xml.lastname user.last_name
                  xml.pics do
                    user.profile_photos.each do |photo|
                      img_path = photo.id.to_s + File.extname(photo.image.original_filename).downcase
                      xml.pic img_path
                      zip.add(img_path, photo.image.path)
                    end
                  end
                  xml.fields do
                    user.profile_field_values.each do |value|
                      xml.field do
                        xml.fieldid value.profile_field.id
                        xml.content value.value == "-" ? "" : value.value
                      end
                    end
                  end
                  xml.about user.about_us_entries.map { |e| e.text.gsub("\r\n", "") }.join("\n")
                end
              end
            end
          end
          
          xml_path = "/tmp/profiles.xml"
          File.open(xml_path, "w") { |f| f.write(builder.to_xml) }
          zip.add("profiles.xml", xml_path)
          zip.close
          File.delete(xml_path)
    
          FileUtils.chmod("a+r", path)
        end
    
        headers['Content-Length'] = File.size(path).to_s
        send_file path
      end
    end
  end
  
  def edit
    redirect_to edit_profile_path if params[:id] && !@_user.admin?
    @photo = Photo.new
  end
  
  def update
    if !locked?
      params[:fields].each do |id, text_value|
        field = ProfileField.find(id)
        value = field.values.where(user_id: @user.id).first_or_initialize
        value.value = text_value
        value.save
      end
      
      flash.notice = t("application.saved_changes")
    end
    
    redirect_to edit_profile_path(params[:id])
  end

  private
  
  def find_fields
    @fields = ProfileField.all
  end
  
  def find_user
    @user = (params[:id] && @_user.admin?) ? User.find(params[:id]) : @_user
  end
end
