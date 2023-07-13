class EndUsersController < ApplicationController
  def show
    @post = Post.new
    @end_user = EndUser.find(params[:id])
    @end_user_posts = @end_user.posts
  end

  def edit
  end

  def confirm
  end

  def withdraw
  end
  
private

  def end_user_params
    params.require(:end_user)
    .permit(:name, :unipue_id, :email, :encrypted_password, :date_of_dirth, 
            :introduction, :private_status, :is_deleted, :profile_image)
  end
  
  
end
