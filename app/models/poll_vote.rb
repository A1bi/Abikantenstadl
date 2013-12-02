class PollVote < BaseModel
  belongs_to :option, class_name: PollOption, touch: true
  belongs_to :user
  
  validates_presence_of :option, :user
end