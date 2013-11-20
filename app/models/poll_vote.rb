class PollVote < BaseModel
  belongs_to :poll
  belongs_to :option, class_name: PollOption
  belongs_to :user
  
  validates_presence_of :poll, :option, :user
end