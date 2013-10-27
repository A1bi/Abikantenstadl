class AddProfileFields < ActiveRecord::Migration
  def change
    create_table :profile_fields do |t|
      t.string   :name
      t.string   :description
      
      t.timestamps
    end
    
    create_table :profile_field_values do |t|
      t.text     :value
      t.integer  :profile_field_id
      t.integer  :user_id
      
      t.timestamps
    end
    
    add_column :users, :student, :boolean, default: true
  end
end
