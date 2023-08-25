class Public::EndUsersController < ApplicationController
  before_action :authenticate_end_user!
  before_action :ensure_nomal_end_user, only: %i[create update destroy withdraw edit]
  before_action :correct_end_user, only: %i[edit]
  helper_method :end_user_status_by?

  def show
    @post = Post.new
    @end_user = EndUser.find(params[:id])
    @end_user_posts = @end_user.posts.order(created_at: :desc).page(params[:page]).per(10)
    @following_end_users = @end_user.following_end_users
    @follower_end_users  = @end_user.follower_end_users
    expires_now
  end

  def post_comment
    @post = Post.new
    @end_user = EndUser.find(params[:id])
    @end_user_comments = PostComment.where(end_user_id: @end_user.id).order(created_at: :desc).page(params[:page]).per(10)
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
      flash[:secondary] = "編集が完了しました"
    else
      @post = Post.new
      render 'edit'
      flash[:secondary] = "編集は失敗しました"
    end
  end

  def confirm
    @end_user = current_end_user.id
  end

  def withdraw
    @end_user = EndUser.find(current_end_user.id)
    @end_user.update(is_deleted: true)
    reset_session
    flash[:secondary] = "退会処理を完了しました"
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
    @end_users = @end_user.follower_end_users.order(created_at: :desc).page(params[:page]).per(10)
  end

private

  def end_user_params
    params.require(:end_user)
    .permit(:name, :unique_id, :email, :date_of_dirth,
            :introduction, :private_status, :is_deleted, :profile_image)
  end

  def ensure_nomal_end_user
    if current_end_user != EndUser.find(params[:id])
      redirect_to posts_path
      flash[:secondary] = '他のユーザーの編集はできません。'
    elsif current_end_user.email == 'guest@example.com'
      redirect_to posts_path
      flash[:secondary] =  'ゲストユーザーは閲覧のみ可能です。'
    end
  end

  def correct_end_user
    @end_user = EndUser.find(params[:id])
    unless @end_user == current_end_user
      redirect_to posts_path
      flash[:secondary] = '他のユーザーの編集画面に遷移はできません。'
    end
  end
  
  def end_user_status_by?
    @end_user.private_status == false ||
    (current_end_user.following?(@end_user) && @end_user.following?(current_end_user)) || 
    @end_user.id == current_end_user.id 
  end

end
