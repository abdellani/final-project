# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_comment, only: %i[edit update destroy]
  before_action only: %i[update edit destroy] do
    owner?(@new_comment.user)
  end

  def create
    @post = Post.find(params[:comment][:post_id])
    @new_comment = Comment.new(content: params[:comment][:content],
                               post_id: params[:comment][:post_id], user_id: current_user.id)
    if @new_comment.save
      redirect_back(fallback_location: root_path)
    else
      render 'posts/show'
    end
  end

  def edit
    @post = @new_comment.post
    render 'posts/show'
  end

  def update
    @post = @new_comment.post
    if @new_comment.update_attributes(content: params[:comment][:content])
      redirect_to post_path(@new_comment.post)
    else
      render 'posts/show'
    end
  end

  def destroy
    post = @new_comment.post
    @new_comment.destroy
    redirect_to post
  end

  private

  def check_comment
    @new_comment = Comment.find(params[:id])
  end
end
