# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  def guest_sign_in
    end_user = EndUser.guest
    sign_in end_user
    redirect_to posts_path, notice:'ゲストとしてログインしました。'
  end
  before_action :reject_end_user, only: [:create]

  def after_sign_in_path_for(resource)
    posts_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

protected

  def reject_end_user
    login = params[:end_user][:login]
    password = params[:end_user][:password]
    @end_user = EndUser.find_by("unique_id = :login OR email = :login", login: login)
    if @end_user&.valid_password?(password)
      if @end_user.is_deleted?
        flash[:secondary] = "このアカウントは退会済みです。"
        redirect_to new_end_user_session_path
      end
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
