class ProfilesController < ApplicationController
  @@lock_time = Time.local(2014, 2, 1, 3)
  
  restrict_access_to_admins only: [:index]
  
  before_filter :find_fields, only: [:edit]
  before_filter :find_user, only: [:edit, :update]
  
  def index
    @fields = ProfileField.all
    @users = User.ordered_by_name.student
  end
  
  def edit
    redirect_to edit_profile_path if params[:id] && !@_user.admin?
    @locked = locked?
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
  
  def locked?
    !@_user.admin? && Time.zone.now >= @@lock_time
  end
end
