class AboutUsEntry < BaseModel
  attr_accessible :text
  
  belongs_to :user
  belongs_to :author, class_name: User
  
  validates_presence_of :author, :user, :text
end
