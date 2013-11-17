class BaseModel < ActiveRecord::Base
  self.abstract_class = true
  
  def self.cache_key
    [table_name, maximum(:updated_at).to_i, except(:limit).count].join("/")
  end
  
  def self.order_by_date_desc
    order("created_at DESC")
  end
end
