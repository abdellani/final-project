require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before :each do
    @user1 = User.create(name:'test1', email:'testgen@test.com', password:'123456')
    @user2 = User.create(name:'test1', email:'testgn@test.com', password:'123456')
  end

  describe '#sender' do
    it 'has to have sender' do
      request = @user2.friendship_received.build()
      request.valid?
      expect(request.errors[:sender]).to include("must exist")

      request = @user2.friendship_received.build(sender: @user1)
      expect(request.valid?).to eql(true)
      expect(request.errors[:sender]).to_not include("must exist")
    end

    it 'creates friendship request' do
      request = @user2.friendship_received.create(sender: @user1)

      expect(request.status).to eql(false)
      expect(Friendship.last.sender).to eql(@user1)
    end
  end
  describe '#receiver' do
    it 'has to have reciver' do
      request = @user1.friendship_sent.build()
      request.valid?
      expect(request.errors[:receiver]).to include("must exist")

      request = @user1.friendship_sent.build(receiver: @user2)
      expect(request.valid?).to eql(true)
      expect(request.errors[:receiver]).to_not include("must exist")
    end

    it 'creates friendship request' do
      request = @user1.friendship_sent.create(receiver: @user2)

      expect(request.status).to eql(false)
      expect(Friendship.last.sender).to eql(@user1)
      expect(Friendship.last.receiver).to eql(@user2)
    end
  end

  describe '#friendship_sent and friendship_recieved' do
    before :each do
      @user3 = User.create(name:'test4', email:'test4@test.com', password:'123456')
      @user4 = User.create(name:'test5', email:'test5@test.com', password:'123456')
      @user1.friendship_sent.create(receiver: @user2, status: true)
      @user1.friendship_sent.create(receiver: @user3)
      @user1.friendship_sent.create(receiver: @user4)
    end

    it 'returns all senders friendships pending and accepted' do
      requests = @user1.friendship_sent
      expect(requests).to include(Friendship.last, Friendship.first)
    end

    it 'returns all recievers friendships pending and accepted' do
      requests = @user4.friendship_received
      expect(requests).to include(Friendship.last)
    end

    it 'returns all accepted friendships' do
      requests = @user2.find_friends
      expect(requests).to include(@user1)
    end

    it 'returns all pending friendships' do
      requests = @user1.pending_friends
      expect(requests).to include(@user3,@user4)
    end

    it 'it returns friendship status between two users' do
      requests = @user1.find_friendships @user2.id
      expect(requests.first.status).to eql(true)
      expect(requests.first.sender).to eql(@user1)
      expect(requests.first.receiver).to eql(@user2)
    end

    it 'it returns friendship status between two users' do
      requests = @user1.find_friendships_pending @user3.id
      expect(requests.first.status).to eql(false)
      expect(requests.first.sender).to eql(@user1)
      expect(requests.first.receiver).to eql(@user3)
    end
  end
end
