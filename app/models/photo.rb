class Photo < BaseModel
  attr_accessible :image
  has_attached_file :image, styles: { thumb: "300x300#" }
  
  belongs_to :user
  
  validates_attachment :image, presence: true, content_type: { content_type: /^image\/(jpeg|png)$/ }
  validates_presence_of :user, :section
  
  def self.section(section)
    where(section: section)
  end
end