class PostCommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id]) # 投稿id
    @post_comment = PostComment.new(post_comment_params) #空のカラムを用意
    @post_comment.end_user_id = current_end_user.id # コメントに投稿するユーザのidを収納
    @post_comment.post_id = @post.id # コメントに投稿idを収納
    if @post_comment.save
      flash[:notice] = 'コメントを投稿しました'
      redirect_to post_path(@post)
    else
      flash[:notice] = 'コメントを失敗しました'
      redirect_to post_path(@post)
    end
  end

  def destroy
    PostComment.find(params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end

private

  def post_comment_params
    params.require(:post_comment).permit(:body)
  end
end
