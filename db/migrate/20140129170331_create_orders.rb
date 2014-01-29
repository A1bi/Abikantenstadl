class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer   :item_id
      t.string    :option
      t.integer   :user_id
      t.timestamps
    end
  end
end
