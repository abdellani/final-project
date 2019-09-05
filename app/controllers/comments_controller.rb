# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_comment, only: %i[edit update destroy]
  before_action only: %i[update edit destroy] do
    owner?(@new_comment.user)
  end

  def create
    @post = Post.find(params[:comment][:post_id])
    @comments = @post.comments
    @comments = @comments.sort { |a, b| a.created_at - b.created_at } unless @comments.empty?
    @new_comment = current_user.comments.build(comment_params)
    if @new_comment.save
      redirect_back(fallback_location: root_path)
    else
      render 'posts/show'
    end
  end

  def edit
    @post = @new_comment.post
    @comments = @post.comments
    @comments = @comments.sort { |a, b| a.created_at - b.created_at } unless @comments.empty?
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

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
