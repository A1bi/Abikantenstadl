class PollOption < BaseModel
  attr_accessible :content
  
  belongs_to :poll
  belongs_to :user
  has_many :votes, class_name: PollVote, :foreign_key => "option_id", dependent: :destroy
  
  validates_presence_of :content, :poll, :user
end