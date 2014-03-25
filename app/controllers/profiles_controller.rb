require "nokogiri"

class ProfilesController < ApplicationController
  include Zippable
  
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
        zip :profiles do |zip|
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
          
          Dir.mktmpdir do |dir|
            path = File.join(dir, "profiles.xml")
            File.open(path, "w") { |f| f.write(builder.to_xml) }
            zip.add("profiles.xml", path)
            zip.commit
          end
        end
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
