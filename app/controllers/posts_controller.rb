class PostsController < ApplicationController

  def create
    @post = Post.new(post_params)
    @post.end_user_id = current_end_user.id
    if @post.save
     redirect_to posts_path
     flash[:notice] = "投稿が成功しました"
    else
      @posts = Post.all
      render 'index'
      flash[:notice] = "投稿が失敗しました"
    end
  end

  def index
    @post = Post.new
    @posts = Post.all
    expires_now
  end

  def edit
    @post = Post.new
    @post_edit = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    # ActiveStorageで紐づけたblobファイルを削除する
    # if params[:post][:post_image_ids]
    #   params[:post][:post_image_ids].each do |image_id|
    #     image = @post.post_images.find(image_id)
    #     image.purge
    #   end
    # end
    # respond_to do |format|
    #   if @post.update(post_params)
    #     format.html { redirect_to edit_post_path(@post.id), notice: "User was successfully updated." }
    #     format.json { render :show, status: :ok, location: @post }
    #   else
    #     format.html { render :edit, status: :unprocessable_entity }
    #     format.json { render json: @post.errors, status: :unprocessable_entity }
    #   end
    # end
    
    if @post.update(post_params)
      redirect_to edit_post_path(@post.id)
      flash[:notice] = "編集が成功しました"
    else
      @post = Post.new
      render 'edit'
      flash[:notice] = "編集は失敗しました"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to posts_path
      flash[:notice] = "削除が成功しました"
    else
      @post = Post.new
      @posts = Post.all
      render 'index'
      flash[:notice] = "削除は失敗しました"
    end
  end
  
  def delete_image
    @post = ActiveStorage::Blob.find_signed(params[:id])
    @post.purge
    redirect_to 'edit'
  end

  private

  def post_params
    params.require(:post).permit(:body, post_images: [])
  end


end
