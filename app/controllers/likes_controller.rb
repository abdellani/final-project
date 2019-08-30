# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  def create
    @like = Like.new
    @like.user = current_user
    @like.post = Post.find(params[:post_id])
    @like.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_user.likes.each { |like| like.destroy if like.post_id == params[:post_id].to_i }
    redirect_back(fallback_location: root_path)
  end
end
