class AboutUsEntry < ActiveRecord::Base
  attr_accessible :text
  
  belongs_to :user
  belongs_to :author, class_name: User
  
  def self.order_by_date_desc
    order("created_at DESC")
  end
end
