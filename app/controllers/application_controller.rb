class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user
  before_filter :restrict_access_to_users
  
  protected
  
  def authenticate_user
    begin
      @_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue
      session[:user_id] = nil
    end
    @_user ||= User.new
  end
  
  def restrict_access_to_users
    redirect_to login_path, :flash => { :warning => t("application.login_required") } if !@_user.id
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
end
