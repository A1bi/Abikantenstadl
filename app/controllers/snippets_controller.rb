class SnippetsController < ApplicationController
  before_filter :find_snippets, only: [:index, :create]
  before_filter :find_snippet, only: [:edit, :update, :destroy]
  
  def index
    @snippet = Snippet.new
    render_index
  end
  
  def create
    @snippet = Snippet.new(params[:snippet])
    @snippet.user = @_user
    @snippet.section = params[:section]
    if @snippet.save
      redirect_to action: :index
    else
      render_index
    end
  end
  
  def edit
    render_edit
  end
  
  def update
    if @snippet.update_attributes(params[:snippet])
      redirect_to action: :index
    else
      render_edit
    end
  end
  
  def destroy
    @snippet.destroy
    redirect_to({ action: :index }, notice: t("application.entry_destroyed"))
  end
  
  private
  
  def find_snippet
    @snippet = Snippet.find(params[:id])
    return redirect_to action: :index if !@_user.admin? && @snippet.user != @_user
  end
  
  def find_snippets
    @snippets = Snippet.section(params[:section]).order_by_date_desc
  end
  
  def render_index
    render_action_in_section(:index)
  end
  
  def render_edit
    render_action_in_section(:edit)
  end
  
  def render_action_in_section(action)
    render "#{action}_#{params[:section]}"
  end
end