# frozen_string_literal: true

class Public::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_nomal_end_user, only: %i[create update destroy]

protected

  # メールアドレスまたはユニークIDとパスワードでログインできる
  def configure_permitted_parameters
    added_attrs = [:name, :unique_id, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
  
  def after_sign_up_path_for(_resource)
     posts_path
  end
  
  def ensure_nomal_end_user
    if current_end_user.email == 'guest@example.com'
      redirect_to root_path, notice: 'ゲストユーザーは閲覧のみ可能となっています。'
    end
  end

end
