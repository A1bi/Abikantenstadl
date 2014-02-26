class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.attachment :file
      t.integer :user_id
      t.timestamps
    end
  end
end
