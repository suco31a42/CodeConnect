class Public::PostImagesController < ApplicationController
  before_action :authenticate_end_user!
    
  def delete_image
    @post = ActiveStorage::Blob.find_signed(params[:id])
    @post.purge
    redirect_to 'edit'
  end
    
end