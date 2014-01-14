class UsersController < ApplicationController
  restrict_access_to_admins except: [:edit_own, :update]
  ignore_restrictions only: [:activate, :finish_activation, :forgot_password, :reset_password]
  
  before_filter :find_user, only: [:edit, :edit_own, :update, :reset, :destroy]

  def activate
    @user = User.where(activation_code: params[:code]).first
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
      render action: :activate
    end
  end

  def update
    if @user.update_attributes(user_params(!params[:own] && @_user.admin?))
      flash.notice = t("application.saved_changes")
      redirect_to params[:own] ? edit_own_path : edit_user_path(@user)
    else
      render action: params[:own] ? :edit_own : :edit
    end
  end
  
  def reset_password
    user = User.where(email: params[:user][:email]).first
    if params[:user][:email].empty? || !user
      flash.alert = t("users.email_not_found") if params[:user][:email].present?
      redirect_to action: :forgot_password
    else
      user.set_activation_code
      user.save
      
      UserMailer.reset_password(user).deliver
      
      flash.notice = t("users.password_reset")
      redirect_to_login
    end
  end
  
  def reset
    @user.reset_password
    @user.save
    send_activation_mail
    redirect_to edit_user_path(@user), notice: t("users.reset")
  end
  
  def index
    @users = User.order(:last_name, :first_name).student
  end
  
  def destroy
    @user.destroy
    redirect_to users_path, notice: t("users.destroyed")
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params(true))
    @user.reset_password
    if @user.save
      send_activation_mail if params[:send_email]
      redirect_to users_path, notice: t("users.created")
    else
      render action: :new
    end
  end

  private
  
  def find_user
    if params[:id] && @_user.admin?
      @user = User.find(params[:id])
    else
      @user = @_user
    end
  end

  def redirect_to_login
    redirect_to login_path
  end
  
  def send_activation_mail
    UserMailer.activation(@user).deliver
  end
  
  def user_params(admin = false)
    params.require(:user).permit(admin ? [:email, :first_name, :last_name, :admin] : [:email, :password, :password_confirmation])
  end
end
