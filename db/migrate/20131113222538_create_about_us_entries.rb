class CreateAboutUsEntries < ActiveRecord::Migration
  def change
    create_table :about_us_entries do |t|
      t.text     :text
      t.integer  :user_id
      t.integer  :author_id

      t.timestamps
    end
  end
end
