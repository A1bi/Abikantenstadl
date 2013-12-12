class Photo < BaseModel
  attr_accessible :image, :assignable_type, :assignable_id
  has_attached_file :image, styles: { thumb: "300x300#" }
  
  belongs_to :user
  belongs_to :assignable, polymorphic: true
  
  validates_attachment :image, presence: true, content_type: { content_type: /^image\/(jpeg|png)$/ }
  validates_presence_of :user
  validates_presence_of :assignable, if: "assignable_id.present?"
  
  def self.not_assigned
    where(assignable_id: nil)
  end
end