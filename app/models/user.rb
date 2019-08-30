class User < ApplicationRecord
  before_create :add_profile_image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :posts, foreign_key: "author_id", dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendship_sent, class_name:"Friendship", 
            foreign_key:"user1_id", dependent: :destroy
  has_many :friendship_received, class_name:"Friendship",
            foreign_key:"user2_id",dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email,format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true

  def find_friendships friend_id
    Friendship.find_by_sql(["SELECT * FROM friendships WHERE  ((user1_id= ? and user2_id = ?) or (user1_id= ? and user2_id = ?)) AND status = true ",self.id,friend_id,friend_id,self.id]) 
  end
  def find_friendships_pending friend_id
    Friendship.find_by_sql(["SELECT * FROM friendships WHERE  ((user1_id= ? and user2_id = ?) or (user1_id= ? and user2_id = ?)) AND status = false ",self.id,friend_id,friend_id,self.id]) 
  end

  def find_friends
    User.find_by_sql(["SELECT * FROM users WHERE id IN (SELECT CASE WHEN user1_id=? THEN user2_id ELSE user1_id END FROM friendships WHERE (user1_id= ? OR user2_id = ?) AND status = true )",self.id,self.id,self.id]) 
  end
  def pending_friends
    User.find_by_sql(["SELECT * FROM users WHERE id IN (SELECT CASE WHEN user1_id=? THEN user2_id ELSE user1_id END FROM friendships WHERE (user1_id= ? OR user2_id = ?) AND status = false )",self.id,self.id,self.id]) 
  end

  private
    def add_profile_image
      gravatar_id = Digest::MD5::hexdigest(self.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
      self.image_link=gravatar_url
    end
end
