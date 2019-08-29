require 'rails_helper'

feature "Like" do
  describe "As authenticated user" do
    before :each do
      @user =User.create(name:"test",email:"test@test.com",password:"123456")
      visit new_user_session_path
      fill_in "user_email", with: "test@test.com"
      fill_in "user_password", with: "123456"
      click_button "Log in"
      expect(page).to have_content("Signed in successfully.")
    end

    scenario 'User can like his posts' do
      @post = @user.posts.create(content: 'text')
      visit root_path
      expect(page).to_not have_content("Likes : 1")
      click_on "Like"
      expect(page).to have_content("Likes : 1")
      expect(page).to have_content("Unlike")
    end

    scenario "User can like other's posts" do
      @user2 = User.create(name:"test2",email:"test2@test.com",password:"123456")
      @post = @user2.posts.create(content: 'text')
      visit root_path
      expect(page).to_not have_content("Likes : 1")
      click_on "Like"
      expect(page).to have_content("Likes : 1")
      expect(page).to have_content("Unlike")
    end

    scenario "User can't like a post more than once" do
      @post = @user.posts.create(content: 'text')
      visit post_path(@post)
      expect(page).to_not have_content("Likes : 1")
      click_on "Like"
      expect(page).to_not have_link("Like")
      expect(page).to have_link("Unlike")
    end

    scenario "User can revoke a like from a post that his liked" do
      @post = @user.posts.create(content: 'text')
      visit post_path(@post)
      expect(page).to_not have_link("Unlike")
      click_on "Like"
      expect(page).to_not have_link("Like")
      expect(page).to have_link("Unlike")
      expect(page).to have_content("Likes : 1")
      click_on "Unlike"
      expect(page).to have_content("Likes : 0")
    end
  end
end