class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
      @post=Post.find(params[:comment][:post_id])
      @new_comment=Comment.new(content:params[:comment][:content], post_id:params[:comment][:post_id],user_id:current_user.id)
      if @new_comment.save
        redirect_to post_path(@post)
      else
        render "posts/show"
      end
  end
  def destroy 
    comment=Comment.find(params[:id])
    post=comment.post
    comment.destroy if comment.user==current_user
    redirect_to post 
  end
end