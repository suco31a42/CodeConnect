class EndUsersController < ApplicationController
  def show
    @post = Post.new
    @end_user = EndUser.find(params[:id])
    @end_user_posts = @end_user.posts
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
  end

  def withdraw
  end

  def follows
    @post = Post.new
    @end_user = EndUser.find(params[:id])
    @end_users = @end_user.following_end_users
  end

  def followers
    @post = Post.new
    @end_user = EndUser.find(params[:id])
    @end_users = @end_user.follower_end_users
  end

private

  def end_user_params
    params.require(:end_user)
    .permit(:name, :unique_id, :email, :date_of_dirth,
            :introduction, :private_status, :is_deleted, :profile_image)
  end


end
