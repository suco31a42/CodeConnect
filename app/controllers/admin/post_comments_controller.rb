class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!
  def destroy
    if PostComment.find(params[:id]).destroy
      redirect_to admin_post_path(params[:post_id])
      flash.now[:secondary] = '削除を完了しました'
    else
      flash.now[:secondary] = '削除は失敗しました'
    end
  end
end
