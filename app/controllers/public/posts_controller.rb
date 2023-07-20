class Public::PostsController < ApplicationController
  before_action :authenticate_end_user!
  before_action :ensure_nomal_end_user, only: %i[update destroy delete_image]
  before_action :correct_end_user, only: [:edit]
  before_action :guest_uncreate, only: [:create]
  
  def create
    @post = Post.new(post_params)
    @post.end_user_id = current_end_user.id
    if @post.save
     redirect_to posts_path
     flash.now[:secondary] = "投稿が成功しました"
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
      expires_now
      return render layout: false if params[:no_layout]
      render 'index'  
      flash.now[:secondary] = "投稿が失敗しました"
    end
  end

  def index
    @post = Post.new
    expires_now
    if    params[:follows]
      @posts = Post.where(end_user_id: [current_end_user.id, *current_end_user.
               following_end_user_ids]).order(created_at: :desc).page(params[:page]).per(10)
    elsif params[:like_count]
      @posts = Post.public_posts.like_count.page(params[:page]).per(10)
    else
      @posts = Post.public_posts.latest.page(params[:page]).per(10)
    end
    return render layout: false if params[:no_layout]
  end

  def show
    @post = Post.new
    @post_id = Post.find(params[:id])
    @post_id_comments = @post_id.post_comments.order(created_at: :desc).page(params[:page]).per(10)
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
      flash.now[:secondary] = "編集が成功しました"
    else
      @post = Post.new
      render 'edit'
      flash.now[:secondary] = "編集は失敗しました"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to posts_path
      flash.now[:secondary] = "削除に成功しました"
    else
      @post = Post.new
      @posts = Post.all
      render 'index'
      flash.now[:secondary] = "削除は失敗しました"
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
  
  def ensure_nomal_end_user
    @post = Post.find(params[:id])
    @end_user = @post.end_user
    if current_end_user != @end_user
      redirect_to posts_path, flash.now[:secondary] = '他のユーザーの編集はできません。'
    elsif current_end_user.email == 'guest@example.com'
      redirect_to posts_path, flash.now[:secondary] = 'ゲストユーザーは閲覧のみ可能です。'
    end
  end
  
  def guest_uncreate
    if current_end_user.email == 'guest@example.com'
      redirect_to posts_path, flash.now[:secondary] = 'ゲストユーザーは閲覧のみ可能です。'
    end
  end

  def correct_end_user
    @post = Post.find(params[:id])
    @end_user = @post.end_user
    unless @end_user == current_end_user
      redirect_to posts_path, flash.now[:secondary] = '他のユーザーの編集画面に遷移はできません。'
    end
  end

end
