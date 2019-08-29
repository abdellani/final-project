require 'rails_helper'

feature "Posts" do
  describe "As authenticated user " do
    before :each do
      @creator=User.create(name:"creator",email:"creator@email.com",password:"123465")
      @post=@creator.posts.create(content:"New post")

      @user =User.create(name:"test_user",email:"test@test.com",password:"123456")
      visit new_user_session_path
      fill_in "user_email", with: "test@test.com"
      fill_in "user_password", with: "123456"
      click_button "Log in"
      expect(page).to have_content("Signed in successfully.")
    end
    scenario "User can comment posts" do 
      visit post_path(@post)
      fill_in "comment_content", with: "This is a new comment"
      click_button "Submit"
      expect(page).to have_current_path(post_path(@post))
      expect(page).to have_content("This is a new comment")
      expect(page).to have_content("test_user")
    end
    scenario "User can remove his comments" do 
      @comment=@post.comments.create(content:"This is a comment",user_id:@user.id)
      visit post_path(@post)
      expect(page).to have_current_path(post_path(@post))
      expect(page).to have_content("This is a comment")
      expect(page).to have_content("test_user")
      click_on "Delete"
      expect(page).to have_current_path(post_path(@post))
      expect(page).to_not have_content("This is a new comment")
      expect(page).to_not have_content("test_user")
    end
    scenario "User can update his comments" do 
      @comment=@post.comments.create(content:"This is a comment",user_id:@user.id)
      visit post_path(@post)
      expect(page).to have_current_path(post_path(@post))
      expect(page).to have_content("This is a comment")
      expect(page).to have_content("test_user")
      click_on "Edit"
      expect(page).to have_current_path(edit_comment_path(@comment))
      fill_in "comment_content", with: "This comment has been updates"
      click_button "Submit"
      expect(page).to have_current_path(post_path(@post))
      expect(page).to_not have_content("This is a comment")
      expect(page).to have_content("test_user")
      expect(page).to have_content("This comment has been updates")
    end
    scenario "User can't edit other user's comments" do 
      @comment=@post.comments.create(content:"This is a comment",user_id:@creator.id)
      visit post_path(@post)
      expect(page).to have_content("This is a comment")
      visit edit_comment_path(@comment)
      expect(page).to have_current_path(root_path)
    end
    scenario "User can't remove other user's comments" do 
      @comment=@post.comments.create(content:"This is a comment",user_id:@creator.id)
      visit post_path(@post)
      expect(page).to have_content("This is a comment")
      page.driver.delete( comment_path(@comment))
      visit post_path(@post)
      expect(page).to have_content("This is a comment")
    end

  end
end