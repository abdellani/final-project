class Friendship < ApplicationRecord
  belongs_to :sender, class_name:"User", foreign_key: "user1_id"
  belongs_to :receiver, class_name:"User", foreign_key: "user2_id" 
end
