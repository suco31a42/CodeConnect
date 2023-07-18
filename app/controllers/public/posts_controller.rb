class Public::PostsController < ApplicationController

  def create
    @post = Post.new(post_params)
    @post.end_user_id = current_end_user.id
    if @post.save
     redirect_to posts_path
     flash[:notice] = "投稿が成功しました"
    else
      if    params[:latest]
        @posts = Post.public_posts.latest.page(params[:page]).per(10)
      elsif params[:follows]
        @posts = Post.where(end_user_id: [current_end_user.id, *current_end_user.
                 following_end_user_ids]).order(created_at: :desc).page(params[:page]).per(10)
      elsif params[:like_count]
        @posts = Post.public_posts.like_count.page(params[:page]).per(10)
      else
        @posts = Post.public_posts.order(created_at: :desc).page(params[:page]).per(10)
      end
      return render layout: false if params[:no_layout]
      render 'index'  
      flash[:notice] = "投稿が失敗しました"
    end
  end

  def index
    @post = Post.new
    if    params[:latest]
      @posts = Post.public_posts.latest.page(params[:page]).per(10)
    elsif params[:follows]
      @posts = Post.where(end_user_id: [current_end_user.id, *current_end_user.
               following_end_user_ids]).order(created_at: :desc).page(params[:page]).per(10)
    elsif params[:like_count]
      @posts = Post.public_posts.like_count.page(params[:page]).per(10)
    else
      @posts = Post.public_posts.order(created_at: :desc).page(params[:page]).per(10)
    end
    return render layout: false if params[:no_layout]
    expires_now
  end

  def show
    @post = Post.new
    @post_id = Post.find(params[:id])
    @post_comment = current_end_user.post_comments.new
  end

  def edit
    @post = Post.new
    @post_edit = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

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
      flash[:notice] = "削除に成功しました"
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

  def bookmarks
    @post = Post.new
    @post_id = current_end_user.bookmark_posts.includes(:end_user).order(created_at: :desc).page(params[:page]).per(10)
  end

  private

  def post_params
    params.require(:post).permit(:body, post_images: [])
  end

  def post_comment_params
    params.require(:post_comment).permit(:body)
  end

end