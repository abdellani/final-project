# frozen_string_literal: true

class AddImageLinkToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :image_link, :string
  end
end
