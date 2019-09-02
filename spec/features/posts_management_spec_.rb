# frozen_string_literal: true

require 'rails_helper'

feature 'Posts' do
  describe 'As authenticated user ' do
    before :each do
      @user = User.create(name: 'test', email: 'test@test.com', password: '123456')
      visit new_user_session_path
      fill_in 'user_email', with: 'test@test.com'
      fill_in 'user_password', with: '123456'
      click_button 'Log in'
      expect(page).to have_content('Signed in successfully.')
    end
    scenario 'User can create post' do
      visit new_post_path
      fill_in 'post_content', with: 'new post'
      click_button 'Create Post'
      expect(page).to have_current_path(root_path)
      expect(page).to have_content("Author : #{@user.name}")
      expect(page).to have_content('Content : new post')
    end
    scenario 'User can update his posts' do
      @post = @user.posts.build(content: 'New post')
      @post.save
      visit post_path @post
      click_on 'Edit'
      expect(page).to have_current_path(edit_post_path(@post))
      fill_in 'post_content', with: 'Edited post'
      click_button 'Update Post'
      expect(page).to have_current_path(post_path(@post))
      expect(page).to have_content('Edited post')
    end
    scenario 'User can delete his posts' do
      @post = @user.posts.build(content: 'New post to delete')
      @post.save
      visit post_path @post
      click_on 'Delete'
      expect(page).to have_current_path(root_path)
      expect(page).not_to have_content('New post to delete')
    end

    scenario 'User can update his posts' do
      @user1 = User.create(name: 'test1', email: 'test1@test.com', password: '123456')
      @post = @user1.posts.build(content: 'New post to delete')
      @post.save
      visit edit_post_path @post
      expect(page).to have_current_path(root_path)
    end

    scenario "User can't delete other's posts" do
      @user1 = User.create(name: 'test1', email: 'test1@test.com', password: '123456')
      @post = @user1.posts.build(content: 'New post to delete')
      @post.save
      visit post_path @post
      click_on 'Delete'
      expect(page).to have_current_path(root_path)
      expect(page).to have_content('New post to delete')
    end
  end
  describe 'As Unauthenticated user ' do
    scenario "Guests can't create new posts" do
      visit new_post_path
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end

    scenario "Guests can't update any posts" do
      user = User.create(name: 'testing', email: 'testing@test.com', password: '123456')
      post = user.posts.build(content: 'post content')
      post.save
      visit edit_post_path(post)
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end

    scenario "Guests can't update any posts" do
      visit posts_path
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end
end
