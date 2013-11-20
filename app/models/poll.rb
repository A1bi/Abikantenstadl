class Poll < BaseModel
  attr_accessible :question, :multiple_choice, :options_attributes
  
  has_many :options, class_name: PollOption, validate: true
  has_many :votes, class_name: PollVote, through: :options
  accepts_nested_attributes_for :options
  
  validates_presence_of :question
  validates_length_of :options, minimum: 2
end