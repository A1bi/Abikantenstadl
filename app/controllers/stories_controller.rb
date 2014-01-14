class StoriesController < ApplicationController
  before_filter :find_stories, only: [:index, :create]
  before_filter :find_story, only: [:edit, :update, :destroy]
  
  def index
    @story = Story.new
  end
  
  def create
    @story = Story.new(story_params)
    @story.user = @_user
    if @story.save
      redirect_to stories_path
    else
      render :index
    end
  end
  
  def update
    if @story.update_attributes(story_params)
      redirect_to({ action: :index }, notice: t("application.saved_changes"))
    else
      render :edit
    end
  end
  
  def destroy
    return redirect_to action: :index if !@_user.admin? && @story.user != @_user
    flash.notice = t("stories.destroyed") if @story.destroy
    redirect_to stories_path
  end
  
  private
  
  def find_story
    @story = Story.find(params[:id])
    return redirect_to action: :index if !@_user.admin? && @story.user != @_user
  end
  
  def find_stories
    @own_stories = @_user.stories.order_by_date_desc
    @all_stories = Story.where("user_id != ?", @_user).order_by_date_desc
  end
  
  def story_params
    params.require(:story).permit(:document, :title)
  end
end