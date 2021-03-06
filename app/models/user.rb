# frozen_string_literal: true

class User < ApplicationRecord
  before_create :add_profile_image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook]

  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendship_sent, class_name: 'Friendship',
                             foreign_key: 'user1_id', dependent: :destroy
  has_many :friendship_received, class_name: 'Friendship',
                                 foreign_key: 'user2_id', dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def find_friendships(friend_id)
    Friendship.find_by_sql(['SELECT * FROM friendships WHERE  ((user1_id= ? and user2_id = ?)
    OR (user1_id= ? and user2_id = ?)) AND status = true ', id, friend_id, friend_id, id])
  end

  def find_friendships_pending(friend_id)
    Friendship.find_by_sql(['SELECT * FROM friendships WHERE  ((user1_id= ? AND user2_id = ?)
    OR (user1_id= ? and user2_id = ?)) AND status = false ', id, friend_id, friend_id, id])
  end

  def find_friends
    User.find_by_sql(['SELECT * FROM users WHERE id IN
    (
      SELECT CASE WHEN user1_id=? THEN user2_id ELSE user1_id END
      FROM friendships WHERE (user1_id= ? OR user2_id = ?) AND status = true
      )', id, id, id])
  end

  def pending_friends
    User.find_by_sql(['SELECT * FROM users WHERE id IN
    (
      SELECT CASE WHEN user1_id=? THEN user2_id ELSE user1_id END
      FROM friendships
       WHERE (user1_id= ? OR user2_id = ?) AND status = false
    )', id, id, id])
  end

  private

  def add_profile_image
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    self.image_link = gravatar_url
  end
end
