class UsersController < ApplicationController
  ignore_restrictions :only => [:activate, :finish_activation, :forgot_password, :reset_password]

  def activate
    @user = User.where(:activation_code => params[:code]).first
    redirect_to_login if !params[:code].present? || @user.nil?
  end

  def finish_activation
    @user = User.find(params[:user][:id])
    return redirect_to_login if @user.activation_code != params[:user][:activation_code]
  
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.valid?
      @user.activate
    
      session[:user_id] = @user.id
    
      flash.notice = (@user.last_login) ? t("users.password_changed") : t("users.activated")
      redirect_to root_path
      
      @user.logged_in
      @user.save
    else
      render :action => :activate
    end
  end

  def update
    if @_user.update_attributes(params[:user], :as => :user)
      flash.notice = t("application.saved_changes")
      redirect_to :action => :edit
    else
      render :action => :edit
    end
  end
  
  def reset_password
    user = User.where(email: params[:user][:email]).first
    if !user
      flash.alert = t("users.email_not_found")
      redirect_to :action => :forgot_password
    else
      user.set_activation_code
      user.save
      
      UserMailer.reset_password(user).deliver
      
      flash.notice = t("users.password_reset")
      redirect_to_login
    end
  end

  private

  def redirect_to_login
    redirect_to login_path
  end
end
