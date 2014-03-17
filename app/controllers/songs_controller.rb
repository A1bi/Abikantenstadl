class SongsController < ApplicationController
  before_action :find_song
  
  def index
    @songs = Song.where.not(user_id: @_user).order(:artist, :title)
    @students = User.student.ordered_by_name.includes(:song).where("songs.id IS NULL")
  end
  
  def update
    response = { file: {} }
    if !@song.update(params.require(:song).permit(:file, :artist, :title))
      @song.errors.delete(:file)
      response[:file][:error] = @song.errors.full_messages.join(', ').html_safe
    else
      response[:file][:html] = render_to_string(@song)
    end
    render json: response
  end
  
  private
  
  def find_song
    @song = @_user.song || @_user.build_song
  end
end