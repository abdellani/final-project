# frozen_string_literal: true

require 'rails_helper'

feature 'Users managment' do
  describe 'Account creation' do
    scenario 'user can  create an account using the signup form' do
      visit new_user_registration_path
      fill_in 'user_name', with: 'test'
      fill_in 'user_email', with: 'test@test.com'
      fill_in 'user_password', with: '123456'
      fill_in 'user_password_confirmation', with: '123456'
      click_button 'Sign up'
      expect(page).to have_content('Welcome! You have signed up successfully')
    end

    scenario "user can't create an account without a name" do
      visit new_user_registration_path
      fill_in 'user_name', with: ''
      fill_in 'user_email', with: 'test@test.com'
      fill_in 'user_password', with: '123456'
      fill_in 'user_password_confirmation', with: '123456'
      click_button 'Sign up'
      expect(page).to have_current_path(user_registration_path)
      expect(page).to have_content("Name can't be blank")
    end

    scenario "user can't create an account with invalid email" do
      visit new_user_registration_path
      fill_in 'user_name', with: 'test'
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: '123456'
      fill_in 'user_password_confirmation', with: '123456'
      click_button 'Sign up'
      expect(page).to have_current_path(user_registration_path)
      expect(page).to have_content("Email can't be blank")
    end

    scenario "user can't create an account with used email" do
      visit new_user_registration_path
      User.create(name: 'test', email: 'test@test.com', password: '123456')
      fill_in 'user_name', with: 'test'
      fill_in 'user_email', with: 'test@test.com'
      fill_in 'user_password', with: '123456'
      fill_in 'user_password_confirmation', with: '123456'
      click_button 'Sign up'
      expect(page).to have_current_path(user_registration_path)
      expect(page).to have_content('Email has already been taken')
    end

    scenario "user can't create an account with weak password" do
      visit new_user_registration_path
      fill_in 'user_name', with: 'test'
      fill_in 'user_email', with: 'test@test.com'
      fill_in 'user_password', with: '12345'
      fill_in 'user_password_confirmation', with: '12345'
      click_button 'Sign up'
      expect(page).to have_current_path(user_registration_path)
      expect(page).to have_content('Password is too short')
    end
  end

  describe 'Authenticated user' do
    before :each do
      @user = User.create(name: 'test', email: 'test@test.com', password: '123456')
      visit new_user_session_path
      fill_in 'user_email', with: 'test@test.com'
      fill_in 'user_password', with: '123456'
      click_button 'Log in'
      expect(page).to have_content('Signed in successfully.')
    end
    scenario "user can't access the login form" do
      visit new_user_session_path
      expect(page).to have_current_path(root_path)
    end
    scenario 'user can see his profile' do
      visit user_path(@user)
      expect(page).to have_current_path(user_path(@user))
      expect(page).to have_content("Name: #{@user.name}")
    end
    scenario 'user can see his profile' do
      second = User.create(name: 'other user', email: 'other@test.com', password: '123456')
      visit user_path(second)
      expect(page).to have_current_path(user_path(second))
      expect(page).to have_content("Name: #{second.name}")
    end
    scenario 'user can edit his profile' do
      visit edit_user_registration_path
      expect(page).to have_current_path(edit_user_registration_path)

      fill_in 'user_name', with: 'changed'
      fill_in 'user_current_password', with: '123456'

      click_button 'Update'

      expect(page).to have_current_path(root_path)
      expect(page).to have_content('Welcome: Changed')
    end
  end
  describe 'Unauthenticated user' do
    it 'should have access to the login page ' do
      visit root_path
      expect(page).to have_current_path(new_user_session_path)
      visit posts_path
      expect(page).to have_current_path(new_user_session_path)
      visit new_post_path
      expect(page).to have_current_path(new_user_session_path)
      visit users_path
      expect(page).to have_current_path(new_user_session_path)
    end
    it 'should have access to the sign up page ' do
      visit new_user_registration_path
      expect(page).to have_current_path(new_user_registration_path)
    end
  end
end
