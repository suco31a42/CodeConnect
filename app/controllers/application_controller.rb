class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def after_sign_in_path_for(resource)
    posts_path
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end
  

  protected

  def configure_permitted_parameters
    # メールアドレスまたはユニークIDとパスワードでログインできる
    added_attrs = [:unique_id, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
  
end
