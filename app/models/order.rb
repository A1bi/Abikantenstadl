class Order < BaseModel
  belongs_to :user
  
  validates_presence_of :user, :item_id
  validates_uniqueness_of :item_id, scope: :user
end