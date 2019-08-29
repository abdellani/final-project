class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates :content, length: {maximum: 255,minimum: 10},presence: true
end
