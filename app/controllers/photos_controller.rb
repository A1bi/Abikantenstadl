require 'zip'
require 'nokogiri'

class PhotosController < ApplicationController
  @@lock_time = Time.local(2014, 3, 1, 0)
  
  before_filter :find_photos, only: [:index, :create]
  
  def index
    respond_to do |format|
      format.html do
        @images_size = Photo.not_assigned.sum(:image_file_size)
      end
      format.zip do
        return redirect_to({ action: :index }, alert: t("application.access_denied")) if !@_user.admin?
        
        path = File.join(Rails.public_path, "system", "archives")
        FileUtils.mkdir_p(path)
        path = File.join(path, "photos.zip")
    
        photos = Photo.not_assigned
        if !File.exists?(path) || File.mtime(path) < photos.maximum(:updated_at)
          FileUtils.rm(path) if File.exists?(path)
    
          Zip::File.open(path, Zip::File::CREATE) do |zip|
            i = 0
            photos.each do |photo|
              zip.add(i.to_s + photo.image.original_filename, photo.image.path)
              i = i.next
            end
          end
    
          FileUtils.chmod("a+r", path)
        end
    
        headers['Content-Length'] = File.size(path).to_s
        send_file path
      end
    end
  end
  
  def create
    @photo = Photo.new(params.require(:photo).permit(:image, :assignable_type, :assignable_id))
    @photo.user = @_user
    @photo.save
    @photo.errors.delete(:image)
    render json: {
      file: @photo.save ? {
        name: @photo.image.name,
        html: render_to_string(@photo)
      } : {
        error: @photo.errors.full_messages.join(', ').html_safe
      }
    }
  end
  
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy if @_user.admin? || @photo.user == @_user
    render nothing: true
  end
  
  private
  
  def find_photos
    @own_photos = @_user.photos.not_assigned
    @all_photos = Photo.where("user_id != ?", @_user).not_assigned
  end
end