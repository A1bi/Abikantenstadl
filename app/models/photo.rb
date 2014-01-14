class Photo < BaseModel
  has_attached_file :image, styles: { thumb: "300x300#" }
  
  belongs_to :user
  belongs_to :assignable, polymorphic: true
  
  validates_attachment :image, presence: true, content_type: { content_type: /^image\/(jpeg|png)$/ }
  validates_presence_of :user
  validates_presence_of :assignable, if: "assignable_id.present?"
  validate :validate_number, on: :create
  
  def self.not_assigned
    where(assignable_id: nil)
  end
  
  private
  
  def validate_number
    max = 3
    errors[:base] << "Max #{max} photos allowed" if assignable.class == User && assignable.profile_photos.count >= max
  end
end