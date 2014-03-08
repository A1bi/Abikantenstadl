class AddArtistAndTitleToSongs < ActiveRecord::Migration
  def change
    change_table :songs do |t|
      t.column :artist, :string
      t.column :title, :string
    end
  end
end
