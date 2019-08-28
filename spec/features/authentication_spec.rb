require 'rails_helper'

feature "Authentication" do
  before :each do 
    @user =User.create(name:"test",email:"test@test.com",password:"123456")
  end
  describe "login" do
    it "should allow user to login" do 
      visit new_user_session_path
      fill_in "user_email", with: "test@test.com"
      fill_in "user_password", with: "123456"
      click_button "Log in"
      expect(page).to have_content("Signed in successfully.")
    end
    it "should not allow user to login with wrong email" do 
      visit new_user_session_path
      fill_in "user_email", with: "wrong@test.com"
      fill_in "user_password", with: "123456"
      click_button "Log in"
      expect(page).to have_content("Invalid Email or password.")
    end
    it "should not allow user to login with wrong password" do 
      visit new_user_session_path
      fill_in "user_email", with: "wrong@test.com"
      fill_in "user_password", with: "123456"
      click_button "Log in"
      expect(page).to have_content("Invalid Email or password.")
    end
  end
  describe "login" do
    it "should allow user to logout after login" do
      visit new_user_session_path
      fill_in "user_email", with: "test@test.com"
      fill_in "user_password", with: "123456"
      click_button "Log in"
      expect(page).to have_content("Signed in successfully.")
      expect(page).to have_content("Logout")
      click_on "Logout"
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
