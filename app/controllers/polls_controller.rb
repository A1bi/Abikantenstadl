class PollsController < ApplicationController
  restrict_access_to_admins only: [:new, :create, :edit, :update, :destroy]
  before_filter :find_poll, only: [:vote, :edit, :update, :destroy]
  
  def index
    @polls = Poll.all
  end
  
  def new
    @poll = Poll.new
  end
  
  def create
    @poll = Poll.new(poll_params)
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
    if @poll.update_attributes(poll_params)
      @poll.touch
      redirect_to edit_poll_path(@poll), notice: t("application.saved_changes")
    else
      render :edit
    end
  end
  
  def destroy
    flash.notice = t("polls.destroyed") if @poll.destroy
    redirect_to polls_path
  end
  
  def results
    render json: { options: find_options }
  end
  
  def vote
    response = {}
    
    @poll.options.update_all(updated_at: Time.now)
    @poll.options.map { |option| option.votes.where(user_id: @_user).delete_all }
    
    (params[:options] ||= []).map! { |id| id.to_i }
    if params[:options_new].present?
      option = @poll.options.where("lower(content) = ?", params[:options_new].downcase).first || @poll.options.build
      if option.new_record?
        option.content = params[:options_new]
        option.user = @_user
        if option.save
          response[:new_option] = render_to_string("_option", layout: false, locals: { option: option, poll: @poll })
          @poll.touch
        end
      end
      if option.persisted?
        if !params[:options].include?(option.id)
          vote = option.votes.build
          vote.user = @_user
          vote.save
        end
        params[:options].clear if !@poll.multiple_choice
      end
    end
    
    params[:options].each do |option|
      next if option.zero?
      option = @poll.options.find(option)
      vote = option.votes.build
      vote.user = @_user
      vote.save
      break if !@poll.multiple_choice
    end
    
    response[:options] = find_options(@poll)
    render json: response
  end
  
  private
  
  def find_poll
    @poll = Poll.find(params[:id])
  end
  
  def find_options(poll = nil)
    options = {}
    (poll.present? ? [poll] : Poll.all).each do |poll|
      options[poll.id] = Rails.cache.fetch([@_user, poll.options]) do
        Hash[poll.options.map do |option|
          [option.id, Rails.cache.fetch([@_user, poll.options, option]) do
            {
              p: Rails.cache.fetch([poll.options, option]) { poll.votes.count.zero? ? 0 : (option.votes.count / poll.votes.count.to_f * 100).round },
              v: option.votes.where(user_id: @_user).any?
            }
          end]
        end]
      end
    end
    options
  end
  
  def poll_params
    params.require(:poll).permit(:question, :multiple_choice, options_attributes: [:id, :content, :_destroy])
  end
end