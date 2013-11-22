class ChangePolls < ActiveRecord::Migration
  def change
    add_column :poll_options, :user_id, :integer
    remove_column :poll_votes, :poll_id
  end
end
