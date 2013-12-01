class SessionsController < ApplicationController
  ignore_restrictions
  skip_filter :reset_goto

  def create
    user = User.where({:email => params[:email]}).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      self.user_id_cookie = user.id if params[:remember].present?
      user.logged_in
      user.save
      redirect_to session[:goto_after_login] || root_path
    else
      flash.now.alert = t("sessions.auth_error")
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    delete_user_id_cookie
    redirect_to login_path, :notice => t("sessions.logout")
  end
end

