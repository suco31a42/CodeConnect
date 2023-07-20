class Admin::EndUsersController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    if params[:oldest]
      @end_users = EndUser.all.order(created_at: :asc).page(params[:page]).per(10)
    else
      @end_users = EndUser.all.order(created_at: :desc).page(params[:page]).per(10)
    end
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
      redirect_to admin_end_user_path(@end_user.id)
      flash.now[:secondary] = '編集を完了しました'
    else
      render :edit
      flash.now[:secondary] = '編集を失敗しました'
    end
  end

private

  def end_user_params
    params.require(:end_user)
    .permit(:name, :unique_id, :email, :date_of_dirth,
            :introduction, :private_status, :is_deleted, :profile_image)
  end

end
