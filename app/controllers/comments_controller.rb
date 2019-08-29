class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
      @post=Post.find(params[:comment][:post_id])
      @new_comment=Comment.new(content:params[:comment][:content], post_id:params[:comment][:post_id],user_id:current_user.id)
      if @new_comment.save
        redirect_back(fallback_location: root_path)
      else
        render "posts/show"
      end
  end

  def edit
    @new_comment = Comment.find(params[:id])
    if current_user == @new_comment.user
      @post = @new_comment.post
      render "posts/show"
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    @new_comment = Comment.find(params[:id])
    @post = @new_comment.post

    
    if current_user == @new_comment.user && @new_comment.update_attributes(content:params[:comment][:content])
      redirect_to post_path(@new_comment.post)
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