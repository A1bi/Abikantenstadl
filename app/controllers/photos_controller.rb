class PhotosController < ApplicationController
  before_filter :find_photos, only: [:index, :create]
  
  def index
    @photo = Photo.new
  end
  
  def create
    @photo = Photo.new(params[:photo])
    @photo.user = @_user
    if @photo.save
      redirect_to_gallery
    else
      if @photo.assignable.present?
        flash.alert = @photo.errors.values.first.first
        redirect_to_gallery
      else
        render :index
      end
    end
  end
  
  def destroy
    @photo = Photo.find(params[:id])
    flash.notice = t("photos.destroyed") if (@_user.admin? || @photo.user == @_user) && @photo.destroy
    redirect_to_gallery
  end
  
  private
  
  def find_photos
    @own_photos = @_user.photos.not_assigned
    @all_photos = Photo.where("user_id != ?", @_user).not_assigned
  end
  
  def redirect_to_gallery
    if @photo.assignable.class == Story
      path = stories_path
    elsif @photo.assignable.class == User
      path = edit_profile_path(@photo.assignable)
    else
      path = photos_path
    end
    redirect_to path
  end
end