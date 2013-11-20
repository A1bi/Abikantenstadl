class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string   :question
      t.boolean  :multiple_choice
      
      t.timestamps
    end
    
    create_table :poll_options do |t|
      t.string   :content
      t.integer  :poll_id
      
      t.timestamps
    end
    
    create_table :poll_votes do |t|
      t.integer  :poll_id
      t.integer  :option_id
      t.integer  :user_id
      
      t.timestamps
    end
  end
end
