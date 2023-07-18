class ApplicationController < ActionController::Base
  before_action :set_search
  

  
  def set_search
    @search = Post.ransack(params[:q])
    @post_result = @search.result
    @post = Post.new
  end

  
end
