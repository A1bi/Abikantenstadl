class Story < BaseModel
  attr_accessible :document, :title
  has_attached_file :document
  
  belongs_to :user
  has_many :photos, as: :assignable, dependent: :destroy
  
  validates_attachment :document, presence: true
  validates_presence_of :user, :title
end