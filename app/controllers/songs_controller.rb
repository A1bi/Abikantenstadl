class SongsController < ApplicationController
  include Zippable
  
  @@lock_time = Time.local(2014, 3, 24, 0)
  
  before_action :find_song
  
  def index
    respond_to do |format|
      students = User.student.ordered_by_name.includes(:song)
      format.html do
        @songs = Song.where.not(user_id: @_user).joins(:user).where(users: { student: true }).order(:artist, :title)
        @students = students.where(songs: { id: nil })
        @size = @songs.sum(:file_file_size)
      end
      format.zip do
        zip_attachments(:songs, students.where.not(songs: { id: nil }).references(:songs), ->(record){ record.song.file }) do |student, attachment, i|
          "#{student.last_name}, #{student.first_name}" + File.extname(attachment.original_filename)
        end
      end
    end
  end
  
  def update
    response = { file: {} }
    if locked? || !@song.update(params.require(:song).permit(:file, :artist, :title))
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