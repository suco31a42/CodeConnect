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

  private

  def post_params
  params.require(:post).permit(:body, :post_image)
end


end
