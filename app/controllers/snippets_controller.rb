class SnippetsController < ApplicationController
  @@lock_time = Time.local(2014, 3, 1, 0)
  
  before_filter :find_snippets, only: [:index, :create]
  before_filter :find_snippet, only: [:edit, :update, :destroy]
  
  def index
    @snippet = Snippet.new
    respond_to do |format|
      format.html do
        render_index
      end
      format.text do
        response = "<ASCII-MAC>\n"
        @snippets.each do |snippet|
          response << snippet.content.gsub("\r\n", "<0x000A>")
          response << "<0x000D>" if snippet != @snippets.last
        end
        send_data response.encode("MacRoman"), type: "text/plain; charset=MacRoman"
      end
    end
  end
  
  def create
    @snippet = Snippet.new(snippet_params)
    @snippet.user = @_user
    @snippet.section = params[:section]
    if @snippet.save && !locked?
      redirect_to_section_index
    else
      render_index
    end
  end
  
  def edit
    render_edit
  end
  
  def update
    if @snippet.update_attributes(snippet_params) && !locked?
      redirect_to_section_index notice: t("application.saved_changes")
    else
      render_edit
    end
  end
  
  def destroy
    @snippet.destroy if !locked?
    render nothing: true
  end
  
  private
  
  def find_snippet
    @snippet = Snippet.find(params[:id])
    return redirect_to_section_index if !@_user.admin? && @snippet.user != @_user
  end
  
  def find_snippets
    @snippets = Snippet.section(params[:section]).order_by_date_desc
    @user_snippets = @_user.snippets.section(params[:section]).order_by_date_desc
    @other_snippets = @snippets.where("user_id != ?", @_user.id)
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
  
  def redirect_to_section_index(opts = {})
    redirect_to send("#{params[:section]}_path"), opts
  end
  
  def snippet_params
    params.require(:snippet).permit(:content)
  end
end