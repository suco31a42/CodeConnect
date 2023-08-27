class Public::LikesController < ApplicationController
  before_action :authenticate_end_user!
  before_action :ensure_nomal_end_user, only: %i[create destroy]
  def create
    @post = Post.find(params[:post_id])
    @like = current_end_user.likes.new(post_id: @post.id)
    @like.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    @like = current_end_user.likes.find_by(post_id: @post.id)
    @like.destroy
  end

private
  def ensure_nomal_end_user
    if current_end_user.email == 'guest@example.com'
      redirect_to posts_path
      flash[:secondary] = 'ゲストユーザーは閲覧のみ可能です。'
    end
  end
end
