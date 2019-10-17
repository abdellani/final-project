# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
    @post = Post.new
  end

  def index
    filter = params[:filter]
    if filter == 'friends'
      @users = current_user.find_friends
    elsif filter == 'pending'
      @users = current_user.friendship_received.map { |u| u.sender if u.receiver == current_user && u.status == false }
      @users.compact!
    else
      @users = User.all
    end
  end
end
