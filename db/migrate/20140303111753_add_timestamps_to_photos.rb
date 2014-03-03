class AddTimestampsToPhotos < ActiveRecord::Migration
  def change
    change_table :photos do |t|
      t.timestamps
    end
  end
end
