class AddDefaultValueToFriendshipStatus < ActiveRecord::Migration[5.1]
  def change
    change_column :friendships, :status, :boolean, default: true
  end
end
