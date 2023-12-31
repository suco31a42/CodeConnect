class Public::PostsController < ApplicationController
  before_action :authenticate_end_user!
  before_action :ensure_nomal_end_user, only: %i[edit update destroy]
  before_action :guest_uncreate, only: [:create]

  def create
    @post = Post.new(post_params)
    @post.end_user_id = current_end_user.id
    if @post.save
      redirect_to posts_path
      flash[:secondary] = "投稿が成功しました"
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
      flash[:secondary] = "投稿が失敗しました"
    end
  end

  def index
    @post = Post.new
    expires_now
    if    params[:follows]
      @posts = Post.public_posts.where(end_user_id: [current_end_user.id, *current_end_user.
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
    @post_id_comments = @post_id.post_comments.page(params[:page]).per(10)
    @post_comment = current_end_user.post_comments.new
  end

  def edit
    @post = Post.new
    @post_edit = Post.find(params[:id])
  end

  def update
    @post_edit = Post.find(params[:id])

    if @post_edit.update(post_params)
      redirect_to edit_post_path(@post_edit.id)
      flash[:secondary] = "編集を保存しました"
    else
      @post = Post.new
      render 'edit'
      flash[:secondary] = "編集は失敗しました"
    end
     #添付画像を個別に削除
    if params[:post][:image_ids]
      params[:post][:image_ids].each do |image_id|
        image = @post_edit.post_images.find(image_id)
        image.purge
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to posts_path
      flash[:secondary] = "削除に成功しました"
    else
      @post = Post.new
      @posts = Post.all
      render 'index'
      flash[:secondary] = "削除は失敗しました"
    end
  end

  def bookmarks
    @post = Post.new
    @posts = current_end_user.bookmark_posts.includes(:end_user).order(created_at: :desc).page(params[:page]).per(10)
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
      redirect_to posts_path
      flash[:secondary] = '他のユーザーの編集はできません'
    elsif current_end_user.email == 'guest@example.com'
      redirect_to posts_path
      flash[:secondary] = 'ゲストユーザーは閲覧のみ可能です'
    end
  end

  def guest_uncreate
    if current_end_user.email == 'guest@example.com'
      redirect_to posts_path
      flash[:secondary] = 'ゲストユーザーは閲覧のみ可能です'
    end
  end

end
