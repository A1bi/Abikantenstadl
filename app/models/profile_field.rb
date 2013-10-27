class ProfileField < BaseModel
  attr_accessible :name, :description
  
  has_many :values, :class_name => ProfileFieldValue
  
  def value_for_user(user)
    value = values.where(user_id: user).first
    value.value if value
  end
end