class Public::NotificationsController < ApplicationController
  before_action :authenticate_end_user!
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
end
