class Public::EndUsersController < ApplicationController
  before_action :authenticate_end_user!
  before_action :ensure_nomal_end_user, only: %i[create update destroy withdraw]
  before_action :correct_end_user, only: %i[edit]

  def show
    @post = Post.new
    @end_user = EndUser.find(params[:id])
    if params[:comment]
      @end_user_posts = @end_user.post_comments.order(created_at: :desc).page(params[:page]).per(10)
    else
      @end_user_posts = @end_user.posts.order(created_at: :desc).page(params[:page]).per(10)
    end
    @following_end_users = @end_user.following_end_users
    @follower_end_users  = @end_user.follower_end_users
    expires_now
  end

  def edit
    @post = Post.new
    @end_user = EndUser.find(params[:id])
  end

  def update
    @end_user = EndUser.find(params[:id])
    if @end_user.update(end_user_params)
      redirect_to end_user_path(@end_user.id)
      flash[:notice] = "編集が成功しました"
    else
      @post = Post.new
      render 'edit'
      flash[:notice] = "編集は失敗しました"
    end
  end

  def confirm
    @end_user = current_end_user.id
  end

  def withdraw
    @end_user = EndUser.find(current_end_user.id)
    @end_user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を完了しました"
    redirect_to root_path
  end

  def follows
    @post = Post.new
    @end_user = EndUser.find(params[:id])
    @end_users = @end_user.following_end_users.order(created_at: :desc).page(params[:page]).per(10)
  end

  def followers
    @post = Post.new
    @end_user = EndUser.find(params[:id])
    @end_users = @end_user.follower_end_users.order(created_at: :desc).ppage(params[:page]).per(10)
  end

private

  def end_user_params
    params.require(:end_user)
    .permit(:name, :unique_id, :email, :date_of_dirth,
            :introduction, :private_status, :is_deleted, :profile_image)
  end

  def ensure_nomal_end_user
    if current_end_user.id != EndUser.find(params[:id])
      redirect_to posts_path, notice: '他のユーザーの編集はできません。'
    elsif current_end_user.email == 'guest@example.com'
      redirect_to posts_path, notice: 'ゲストユーザーは閲覧のみ可能です。'
    end
  end

  def correct_end_user
    @end_user = EndUser.find(params[:id])
    unless @end_user == current_end_user
      redirect_to posts_path, notice: '他のユーザーの編集画面に遷移はできません。'
    end
  end

end
