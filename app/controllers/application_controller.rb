class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search
  
  def after_sign_in_path_for(resource)
    posts_path
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end
  
  def set_search
    @search = Post.ransack(params[:q])
    @post_result = @search.result
    @post = Post.new
  end
  
  protected

  # メールアドレスまたはユニークIDとパスワードでログインできる
  def configure_permitted_parameters
    added_attrs = [:name, :unique_id, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
  
end
