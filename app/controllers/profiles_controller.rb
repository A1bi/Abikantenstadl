class ProfilesController < ApplicationController
  before_filter :find_fields, only: [:edit]
  before_filter :find_user, only: [:edit, :update]
  
  def index
    @fields = ProfileField.scoped
    @users = User.order(:last_name, :first_name).student
  end
  
  def update
    params[:fields].each do |id, text_value|
      field = ProfileField.find(id)
      value = ProfileFieldValue.where(profile_field_id: field.id, user_id: @user.id).first_or_initialize
      value.value = text_value
      value.save
    end
    
    redirect_to edit_profile_path(params[:id]), notice: t("application.saved_changes")
  end

  private
  
  def find_fields
    @fields = ProfileField.scoped
  end
  
  def find_user
    @user = (params[:id] && @_user.admin?) ? User.find(params[:id]) : @_user
  end
end
