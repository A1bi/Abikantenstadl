class PollOption < BaseModel
  attr_accessible :content
  
  belongs_to :poll
  has_many :votes, class_name: PollVote, :foreign_key => "option_id"
  
  validates_presence_of :content, :poll
end