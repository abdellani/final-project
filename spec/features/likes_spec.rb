# frozen_string_literal: true

require 'rails_helper'

feature 'Like' do
  describe 'As authenticated user' do
    before :each do
      @user = User.create(name: 'test', email: 'test@test.com', password: '123456')
      visit new_user_session_path
      fill_in 'user_email', with: 'test@test.com'
      fill_in 'user_password', with: '123456'
      click_button 'Log in'
      expect(page).to have_content('Signed in successfully.')
    end

    scenario 'User can like his posts' do
      @post = @user.posts.create(content: 'text')
      visit root_path
      expect(page).to have_content('Like : 0')
      expect(page).to have_css('.fa-thumbs-up')
      click_link(class: 'fa-thumbs-up')
      expect(page).to have_content('Like : 1')
      expect(page).to have_css('.fa-thumbs-down')
    end

    scenario "User can like other's posts" do
      @user2 = User.create(name: 'test2', email: 'test2@test.com', password: '123456')
      @post = @user2.posts.create(content: 'text')
      Friendship.create(sender:@user,receiver:@user2,status:true)
      visit root_path
      expect(page).to have_content('Like : 0')
      click_link(class: 'fa-thumbs-up')
      expect(page).to have_content('Like : 1')
      expect(page).to have_css('.fa-thumbs-down')
    end

    scenario "User can't like a post more than once" do
      @post = @user.posts.create(content: 'text')
      visit post_path(@post)
      expect(page).to have_content('Like : 0')
      expect(page).to have_css('.fa-thumbs-up')
      click_link(class: 'fa-thumbs-up')
      expect(page).to have_content('Like : 1')
      expect(page).to have_css('.fa-thumbs-down')
      page.driver.post(likes_path(id:@post.id))
      expect(page).to have_content('Like : 1')
      expect(page).to have_css('.fa-thumbs-down')
    end

    scenario 'User can revoke a like from a post that his liked' do
      @post = @user.posts.create(content: 'text')
      visit post_path(@post)
      expect(page).to have_css('.fa-thumbs-up')
      click_link(class: 'fa-thumbs-up')
      expect(page).to_not have_css('.fa-thumbs-up')
      expect(page).to have_css('.fa-thumbs-down')
      expect(page).to have_content('Like : 1')
      click_link(class: 'fa-thumbs-down')
      expect(page).to have_content('Like : 0')
    end
  end
end
