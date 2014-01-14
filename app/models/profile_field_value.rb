class ProfileFieldValue < BaseModel
  belongs_to :user
  belongs_to :profile_field
  
  def self.not_empty
    where(self.arel_table[:value].not_eq(""))
  end
end