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
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id)
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

  private

  def post_params
  params.require(:post).permit(:body, :post_image)
end


end
