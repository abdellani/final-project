require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "Content" do
    before :each do 
      @creator=User.create(name:"creator",email:"creator@email.com",password:"123465")
      @post=@creator.posts.create(content:"New post")
      @comment=@post.comments.create(content:"this a comment",user_id:@creator.id)
      expect(@comment.valid?).to eql(true)
    end
    it "should be not be empty" do
      @comment.content=""
      expect(@comment.valid?).to eql(false)
    end
    it "should not exceed 255 characters" do 
      @comment.content= "A"*256
      expect(@comment.valid?).to eql(false)
   end
    it "should belong to an author" do 
      @comment.user= nil
      expect(@comment.valid?).to eql(false)
    end
    it "should belong to a post" do 
      @comment.post = nil
      expect(@comment.valid?).to eql(false)
    end
  end
end
