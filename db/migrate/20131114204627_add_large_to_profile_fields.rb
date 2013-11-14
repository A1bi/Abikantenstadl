class AddLargeToProfileFields < ActiveRecord::Migration
  def change
    add_column :profile_fields, :large, :boolean, default: false
  end
end
