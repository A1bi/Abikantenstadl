class SessionsController < ApplicationController
  ignore_restrictions

  def create
    user = User.where({:email => params[:email]}).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      user.logged_in
      user.save
      redirect_to root_path
    else
      flash.now.alert = t("sessions.auth_error")
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, :notice => t("sessions.logout")
  end
end

