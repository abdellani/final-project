# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates :content, length: { maximum: 255 }, presence: true
end
