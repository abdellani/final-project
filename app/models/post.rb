class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :comments,  dependent: :destroy
  validates :content, length: {maximum: 255},presence: true
end
