class Poll < BaseModel
  attr_accessible :question, :multiple_choice, :options_attributes
  
  has_many :options, class_name: PollOption, validate: true, dependent: :destroy
  has_many :votes, class_name: PollVote, through: :options
  accepts_nested_attributes_for :options, allow_destroy: true
  
  validates_presence_of :question
end