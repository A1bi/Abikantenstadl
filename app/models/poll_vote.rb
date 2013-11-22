class PollVote < BaseModel
  belongs_to :option, class_name: PollOption
  belongs_to :user
  
  validates_presence_of :option, :user
end