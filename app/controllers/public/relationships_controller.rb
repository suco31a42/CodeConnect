class Public::RelationshipsController < ApplicationController

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
end
