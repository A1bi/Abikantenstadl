class Photo < BaseModel
  has_attached_file :image, styles: { thumb: "300x300#" }
  
  belongs_to :user
  belongs_to :assignable, polymorphic: true
  
  validates_attachment :image, presence: true, content_type: { content_type: /^image\/(jpe?g|png)$/ }
  validates_presence_of :user
  validates_presence_of :assignable, if: "assignable_id.present?"
  validate :validate_number, on: :create
  
  def self.not_assigned
    where(assignable_id: nil)
  end
  
  def self.accepted_types
    "image/jpg, image/jpeg, image/png"
  end
  
  private
  
  def validate_number
    max = 3
    if assignable.class == User && assignable.profile_photos.count >= max
      errors[:base] << I18n.t("errors.models.photo.too_many", max: max)
    end
  end
end