class AddAttachmentImageToPhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.attachment :image
      t.integer :user_id
      t.string :section
    end
  end

  def self.down
    drop_attached_file :photos, :image
    drop_table :photos
  end
end
