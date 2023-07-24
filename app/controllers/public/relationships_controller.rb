class Public::RelationshipsController < ApplicationController
  before_action :authenticate_end_user!
  before_action :ensure_nomal_end_user, only: %i[create]
  def create
   @end_user = EndUser.find(params[:end_user_id])
    current_end_user.follow(params[:end_user_id])
  end

  def destroy
    @end_user = EndUser.find(params[:end_user_id])
    current_end_user.unfollow(params[:end_user_id])
  end

  def follows
    @end_user = EndUser.find(params[:id])
    @end_users = @end_user.following_end_users
  end

  def followers
    @end_user = EndUser.find(params[:id])
    @end_users = @end_user.follower_end_users
  end
  
private
  
  def ensure_nomal_end_user
    if current_end_user.email == 'guest@example.com'
      redirect_to posts_path
      flash[:secondary] = 'ゲストユーザーは閲覧のみ可能です。'
    end
  end
end
