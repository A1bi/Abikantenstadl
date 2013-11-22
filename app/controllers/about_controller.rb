class AboutController < ApplicationController
  before_filter :find_user, only: [:show_user, :create]
  before_filter :find_entry, only: [:destroy, :edit, :update]
  before_filter :find_entries, only: [:show_user, :create]
  before_filter :restrict_access_to_edit, only: [:edit, :update]
  
  def index
    @users = User.student.ordered_by_name
  end
  
  def show_user
    @entry = AboutUsEntry.new
  end
  
  def create
    @entry = @user.about_us_entries.build(params[:about_us_entry])
    @entry.author = @_user
    if @entry.save
      redirect_to about_user_path(@user)
    else
      render :show_user
    end
  end
  
  def update
    if @entry.update_attributes(params[:about_us_entry])
      redirect_to about_user_path(@entry.user), notice: t("application.saved_changes")
    else
      render :edit
    end
  end
  
  def destroy
    @entry.destroy
    redirect_to about_user_path(@entry.user), notice: t("application.entry_destroyed")
  end
  
  private
  
  def find_user
    @user = User.find(params[:user])
  end
  
  def find_entry
    @entry = AboutUsEntry.find(params[:entry])
    if !@_user.admin? && @entry.author != @_user && @entry.user != @_user
      return redirect_access_denied
    end
  end
  
  def find_entries
    entries = @user.about_us_entries.order_by_date_desc
    @own_entries = entries.where(author_id: @_user)
    @other_entries = entries.where("author_id != ?", @_user)
  end
  
  def restrict_access_to_edit
    return redirect_access_denied if @entry.user == @_user
  end
  
  def redirect_access_denied
    redirect_to about_user_path(@entry.user), alert: t("application.access_denied")
  end
end
