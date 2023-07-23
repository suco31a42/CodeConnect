class ApplicationController < ActionController::Base
  before_action :set_search


  def set_search
    @search = Post.ransack(params[:q])
    @post_result = @search.result.order(created_at: :desc).page(params[:page]).per(10)
    @post = Post.new
  end

end
