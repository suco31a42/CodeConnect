class BookmarksController < ApplicationController
  def index
    
  end
  
  def create
    @post = Post.find(params[:post_id])
    @bookmark = current_end_user.bookmarks.new(post_id: @post.id)
    @bookmark.save
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @bookmark = current_end_user.bookmarks.find_by(post_id: @post.id)
    @bookmark.destroy
  end
end
