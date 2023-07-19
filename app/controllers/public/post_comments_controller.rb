class Public::PostCommentsController < ApplicationController
  before_action :ensure_nomal_end_user, only: [:destroy]
  before_action :guest_uncreate, only: [:create]
  def create
    @post = Post.find(params[:post_id]) # 投稿id
    @post_comment = PostComment.new(post_comment_params) #空のカラムを用意
    @post_comment.end_user_id = current_end_user.id # コメントに投稿するユーザのidを収納
    @post_comment.post_id = @post.id # コメントに投稿idを収納
    if @post_comment.save
      flash[:notice] = 'コメントを投稿しました'
      redirect_to post_path(@post)
    else
      flash[:notice] = 'コメントを失敗しました'
      redirect_to post_path(@post)
    end
  end

  def destroy
    PostComment.find(params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end

private

  def post_comment_params
    params.require(:post_comment).permit(:body)
  end
  
  def ensure_nomal_end_user
    if current_end_user.id != EndUser.find(params[:id])
      redirect_to posts_path, alert: '他のユーザーのコメントは削除できません。'
    elsif current_end_user.email == 'guest@example.com'
      redirect_to posts_path, alert: 'ゲストユーザーは閲覧のみ可能です。'
    end
  end
  
  def guest_uncreate
    if current_end_user.email == 'guest@example.com'
      redirect_to posts_path, notice: 'ゲストユーザーは閲覧のみ可能です。'
    end
  end
  
end
