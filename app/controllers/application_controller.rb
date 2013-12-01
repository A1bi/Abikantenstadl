class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user
  before_filter :restrict_access_to_users
  prepend_before_filter :reset_goto
  
  protected
  
  def authenticate_user
    begin
      session[:user_id] ||= user_id_cookie if user_id_cookie.present?
      @_user ||= User.find(session[:user_id]) if session[:user_id].present?
    rescue
      session[:user_id] = nil
    end
    @_user ||= User.new
  end
  
  def restrict_access_to_users
    if !@_user.id
      session[:goto_after_login] = request.original_url
      redirect_to login_path, :flash => { :warning => t("application.login_required") }
    end
  end
  
  def restrict_access_to_admins
    redirect_to root_path, :alert => t("application.access_denied") if !@_user.admin?
  end
  
  def self.restrict_access_to_admins(options = {})
    before_filter :restrict_access_to_admins, options
  end
  
  def self.ignore_restrictions(options = {})
    skip_filter :restrict_access_to_users, :restrict_access_to_admins, options
  end
  
  def user_id_cookie
    cookies.signed[user_id_cookie_name]
  end
  
  def user_id_cookie=(value)
    cookies.permanent.signed[user_id_cookie_name] = value
  end
  
  def delete_user_id_cookie
    cookies.delete user_id_cookie_name
  end
  
  private
  
  def user_id_cookie_name
    "_#{Rails.application.class.parent_name}_user_id"
  end
  
  def reset_goto
    session.delete(:goto_after_login)
  end
end
