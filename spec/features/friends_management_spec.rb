# frozen_string_literal: true

require 'rails_helper'

feature 'Friendship management' do
  describe 'As authenticated user ' do
    before :each do
      @friend = User.create(name: 'friend_user', email: 'friend@email.com', password: '123465')

      @user = User.create(name: 'test_user', email: 'test@test.com', password: '123456')
      visit new_user_session_path
      fill_in 'user_email', with: 'test@test.com'
      fill_in 'user_password', with: '123456'
      click_button 'Log in'
      expect(page).to have_content('Signed in successfully.')
    end

    scenario 'User can add friend' do
      visit user_path @friend
      expect(page).to have_content("#{@friend.name}")
      expect(page).to have_content("#{@friend.email}")
      expect(page).to have_content('Add as friend')
      click_on 'Add as friend'
      expect(page).to have_current_path(user_path(@friend))
      expect(page).to have_content("request pending")
      request = Friendship.find_by(user1_id: @user.id)
      expect(request.receiver).to eql(@friend)
    end
    scenario 'User can unfriend a friend' do
      Friendship.create(sender: @user, receiver: @friend, status: true)
      visit user_path @friend
      expect(page).to have_content("#{@friend.name}")
      expect(page).to have_content("#{@friend.email}")
      expect(page).to have_content('Remove friend')
      click_on 'Remove friend'
      expect(page).to have_current_path(user_path(@friend))
      expect(page).to have_content("#{@friend.name}")
      expect(page).to have_content("#{@friend.email}")
      expect(page).to have_content('Add as friend')
      request = Friendship.find_by(user1_id: @user.id)
      expect(request.nil?).to eql(true)
    end

    scenario 'User can accept friendship request' do
      Friendship.create(sender: @friend, receiver: @user, status: false)
      visit user_path @friend
      expect(page).to have_content("#{@friend.name}")
      expect(page).to have_content("#{@friend.email}")
      expect(page).to have_content('Accept friendship')
      expect(page).to have_content('Reject friendship')
      click_on 'Accept friendship'
      visit user_path @friend
      expect(page).to have_current_path(user_path(@friend))
      expect(page).to have_content("#{@friend.name}")
      expect(page).to have_content("#{@friend.email}")
      expect(page).to have_content('Remove friend')
      request = Friendship.find_by(user2_id: @user.id)
      expect(request.receiver).to eql(@user)
    end

    scenario 'User can decline friendship request' do
      Friendship.create(sender: @friend, receiver: @user, status: false)
      visit user_path @friend
      expect(page).to have_content("#{@friend.name}")
      expect(page).to have_content("#{@friend.email}")
      expect(page).to have_content('Accept friendship')
      expect(page).to have_content('Reject friendship')
      click_on 'Reject friendship'
      visit user_path @friend
      expect(page).to have_current_path(user_path(@friend))
      expect(page).to have_content("#{@friend.name}")
      expect(page).to have_content("#{@friend.email}")
      expect(page).to have_content('Add as friend')
      request = Friendship.find_by(user2_id: @user.id)
      expect(request.nil?).to eql(true)
    end
    scenario 'User gets notifiation about friendship requrest' do
      Friendship.create(sender: @friend, receiver: @user, status: false)
      visit users_path(filter: 'pending')
      expect(page).to have_content(@friend.name.to_s)
      expect(page).to have_content('Accept friendship')
      expect(page).to have_content('Reject friendship')
    end
    scenario 'User can see if request is pending' do
      visit user_path @friend
      expect(page).to have_content("#{@friend.name}")
      expect(page).to have_content("#{@friend.email}")
      expect(page).to have_content('Add as friend')
      click_on 'Add as friend'
      expect(page).to have_current_path(user_path(@friend))
      expect(page).to have_content('request pending')
    end

    scenario 'User can see a list of friends' do
      Friendship.create(sender: @user, receiver: @friend, status: true)
      visit users_path(filter: 'friends')
      expect(page).to have_content(@friend.name.to_s)
      expect(page).to have_content('Remove friend')
    end
  end
end
