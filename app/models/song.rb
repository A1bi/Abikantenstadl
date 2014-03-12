class Song < BaseModel
  has_attached_file :file
  
  belongs_to :user
  
  validates_attachment :file, presence: true, content_type: { content_type: /^audio\/(mp(eg3?|4)|vnd.wav|aacp?|(x-)?m4a)$/ }
  validates_presence_of :user
  
  def self.accepted_types
    "audio/mpeg, audio/mpeg3, audio/vnd.wav, audio/aac, audio/aacp, audio/mp4, audio/m4a, audio/x-m4a"
  end
end