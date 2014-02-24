class PhotosController < ApplicationController
  before_filter :find_photos, only: [:index, :create]
  
  def index
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