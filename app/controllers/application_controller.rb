class ApplicationController < ActionController::Base
  before_action :set_search


  def set_search
    @post = Post.new
    @q_posts = Post.ransack(params[:q])
    @posts = @q_posts.result.public_posts.order(created_at: :desc).page(params[:page]).per(10)

    @q_end_users = EndUser.ransack(params[:q])
    @end_users = @q_end_users.result.order(created_at: :desc).page(params[:page]).per(10)
  end

end
