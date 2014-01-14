class Snippet < BaseModel
  belongs_to :user
  
  validates_presence_of :content, :user, :section
  
  def self.section(section)
    where(section: section)
  end
end
