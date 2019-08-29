class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :comments,  dependent: :destroy
  has_many :likes,  dependent: :destroy
  validates :content, length: {maximum: 255},presence: true
end
