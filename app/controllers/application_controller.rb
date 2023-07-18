class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search
  before_action :reject_end_user, only: [:create]

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

  def reject_end_user
    login = params[:end_user][:login]
    password = params[:end_user][:password]
    @end_user = EndUser.find_by("unique_id = :login OR email = :login", login: login)
    if @end_user&.valid_password?(password)
      if @end_user.is_deleted?
        flash[:notice] = "このアカウントは退会済みです。再度ご登録をしてご利用下さい"
        redirect_to new_end_user_registration_path
      end
    else
      flash[:notice] = "該当するユーザーが見つかりません"
    end
  end
end
