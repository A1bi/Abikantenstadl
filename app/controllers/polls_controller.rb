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
      option = @poll.options.build(content: option)
      option.poll = @poll
      option.user = @_user
    end
    if @poll.save
      redirect_to polls_path
    else
      render :new
    end
  end
  
  def update
    if @poll.update_attributes(params[:poll])
      redirect_to edit_poll_path(@poll), notice: t("application.saved_changes")
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
    
    params[:options] ||= []
    if params[:options_new].present?
      option = @poll.options.where("lower(content) = ?", params[:options_new].downcase).first || @poll.options.build
      if option.new_record?
        option.content = params[:options_new]
        option.user = @_user
        option.save
      end
      if option.persisted?
        vote = option.votes.build
        vote.user = @_user
        vote.save
        params[:options].clear if !@poll.multiple_choice
        flash.notice ||= t("polls.voted_option_created")
      end
    end
    
    params[:options].each do |option|
      option = @poll.options.find(option)
      vote = option.votes.build
      vote.user = @_user
      vote.save
      break if !@poll.multiple_choice
    end
    
    flash.notice ||= t("polls.voted")
    redirect_to polls_path
  end
  
  private
  
  def find_poll
    @poll = Poll.find(params[:id])
  end
end