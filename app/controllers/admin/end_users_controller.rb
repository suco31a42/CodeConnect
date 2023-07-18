class Admin::EndUsersController < ApplicationController
  def index
    @end_user = EndUser.all.order(created_at: :desc)
  end

  def show
    @end_user = EndUser.find(params[:id])
  end

  def edit
    @end_user = EndUser.find(params[:id])
  end
  
  def update
    @end_user = EndUser.find(params[:id])
    if @end_user.update(end_user_params)
      redirect_to admin_end_user(@end_user.id)
    else
      render :edit
    end
  end
  
private

  def end_user_params
    params.require(:end_user)
    .permit(:name, :unique_id, :email, :date_of_dirth,
            :introduction, :private_status, :is_deleted, :profile_image)
  end
  
end
