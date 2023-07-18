class Admin::PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
  end
  
  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to admin_posts
      flash[:notice] = "削除に成功しました"
    else
      render 'show'
      flash[:notice] = "削除は失敗しました"
    end
  end
end
