# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  def create
    @user = User.find_by_id(params[:user_id])
    return unless @user

    friendship_request = current_user.friendship_sent.build(receiver: @user)
    if friendship_request.save
      redirect_to user_path(@user)
    else
      redirect_to root_path
    end
  end

  def update
    user = User.find_by_id(params[:id])
    return unless user

    friendship = user.find_friendships_pending(current_user.id).first
    friendship&.update_attributes(status: true)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    user = User.find_by_id(params[:id])
    status = params[:status]
    return unless user

    friendship = if status == 'pending'
                   user.find_friendships_pending(current_user.id).first
                 else
                   user.find_friendships(current_user.id).first
                 end
    friendship&.destroy
    redirect_back(fallback_location: root_path)
  end
end
