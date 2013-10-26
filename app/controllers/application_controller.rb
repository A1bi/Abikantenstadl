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
    if !@_user.id
      return redirect_to login_path, :flash => { :warning => t("application.login_required") }
    end
  end
  
  def restrict_access_to_admins
    if !@_user.admin?
      return redirect_to root_path, :alert => t("application.access_denied")
    end
  end
  
  def self.ignore_restrictions(options = {})
    skip_filter :restrict_access_to_users, options
  end
end
