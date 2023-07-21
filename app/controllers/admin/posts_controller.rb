class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
    @post_comments = @post.post_comments.order(created_at: :desc).page(params[:page]).per(10)
  end
  
  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to admin_posts_path
      flash.now[:secondary] = "削除に成功しました"
    else
      @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
      render 'show'
      flash.now[:secondary] = "削除は失敗しました"
    end
  end
end
