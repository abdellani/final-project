class AddDefaultValueFalseToFriendshipStatus < ActiveRecord::Migration[5.1]
  def change
    change_column :friendships, :status, :boolean, default: false
  end
end
