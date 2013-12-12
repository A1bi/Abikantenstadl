class AddStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title
      t.attachment :document
      t.integer :user_id
      t.timestamps
    end
  end
  
  def migrate(direction)
    super
    
    change_table :photos do |t|
      if direction == :up
        t.references :assignable, polymorphic: true
        t.remove :section
      else
        t.remove_references :assignable, polymorphic: true
        t.string :section
      end
    end
  end
end
