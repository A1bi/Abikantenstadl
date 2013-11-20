class PollsController < ApplicationController
  restrict_access_to_admins only: [:new, :create, :edit, :update, :destroy]
  before_filter :find_poll, only: [:vote, :edit, :update, :destroy]
  
  def index
    @polls = Poll.scoped
  end
  
  def new
    @poll = Poll.new
  end
  
  def create
    @poll = Poll.new(params[:poll])
    params[:options].each do |option|
      next if option.blank?
      @poll.options.build(content: option).poll = @poll
    end
    if @poll.save
      redirect_to polls_path
    else
      render :new
    end
  end
  
  def update
    if @poll.update_attributes(params[:poll])
      redirect_to polls_path, notice: t("application.saved_changes")
    else
      render :edit
    end
  end
  
  def destroy
    flash.notice = t("polls.destroyed") if @poll.destroy
    redirect_to polls_path
  end
  
  def vote
    @poll.votes.where(user_id: @_user).destroy_all
    (params[:options] || []).each do |option|
      vote = @poll.votes.build
      vote.poll = @poll
      vote.option = @poll.options.find(option)
      vote.user = @_user
      vote.save
      break if !@poll.multiple_choice
    end
    redirect_to polls_path, notice: t("polls.voted")
  end
  
  private
  
  def find_poll
    @poll = Poll.find(params[:id])
  end
end