class PhotosController < ApplicationController
  before_filter :find_photos, only: [:index, :create]
  
  def index
    @photo = Photo.new
  end
  
  def create
    @photo = Photo.new(params[:photo])
    @photo.user = @_user
    @photo.section = :collage
    if @photo.save
      redirect_to photos_path
    else
      render :index
    end
  end
  
  def destroy
    photo = Photo.find(params[:id])
    flash.notice = t("photos.destroyed") if photo.destroy
    redirect_to photos_path
  end
  
  private
  
  def find_photos
    @photos = Photo.where(user_id: @_user).section(:collage)
  end
end