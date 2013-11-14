class AboutController < ApplicationController
  before_filter :find_user, only: [:show_user, :create]
  before_filter :find_entry, only: [:destroy, :edit, :update]
  
  def index
    @users = User.student.ordered_by_name
  end
  
  def show_user
    entries = @user.about_us_entries.order_by_date_desc
    @own_entries = entries.where(author_id: @_user)
    @other_entries = entries.where("author_id != ?", @_user)
  end
  
  def create
    entry = @user.about_us_entries.build(params[:about_us_entry])
    entry.author = @_user
    if entry.save
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
    if @_user.admin? || @entry.author == @_user
      @entry.destroy
      flash.notice = t("about.destroyed")
    end
    redirect_to about_user_path(@entry.user)
  end
  
  private
  
  def find_user
    @user = User.find(params[:user])
  end
  
  def find_entry
    @entry = AboutUsEntry.find(params[:entry])
  end
end
