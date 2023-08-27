class Public::NotificationsController < ApplicationController
  before_action :authenticate_end_user!
  before_action :ensure_nomal_end_user, only: %i[destroy_all]
  def index
    @notifications = current_end_user.notifications.order(created_at: :desc).page(params[:page]).per(20)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
  
  def destroy_all
    current_end_user.notifications.destroy_all
    redirect_to notifications_path
  end
  
private
  
  def ensure_nomal_end_user
    if current_end_user != EndUser.find(params[:id])
      redirect_to posts_path
      flash[:secondary] = '他のユーザーの通知の削除はできません。'
    elsif current_end_user.email == 'guest@example.com'
      redirect_to posts_path
      flash[:secondary] =  'ゲストユーザーは閲覧のみ可能です。'
    end
  end
  
end
