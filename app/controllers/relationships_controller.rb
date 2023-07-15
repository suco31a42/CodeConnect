class RelationshipsController < ApplicationController

  def create
    current_end_user.follow(params[:end_user_id])

  end

  def destroy
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
