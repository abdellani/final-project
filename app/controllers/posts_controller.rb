# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_owner, only: %i[update edit destroy]
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    user = current_user
    post = user.posts.build(post_params)
    if post.save
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(content: params[:post][:content])
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
    @new_comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path
  end

  private

  def check_owner
    @post = Post.find(params[:id])
    redirect_to root_path if current_user != @post.author
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
