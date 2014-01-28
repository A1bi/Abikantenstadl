class AboutUsEntry < BaseModel
  belongs_to :user
  belongs_to :author, class_name: User
  
  validates_presence_of :author, :user, :text
  validate :author_is_not_user
  
  private
  
  def author_is_not_user
    errors.add(:user, I18n.t("activerecord.errors.models.about_us_entry.attributes.user.same_as_author")) if user.present? && author == user
  end
end
