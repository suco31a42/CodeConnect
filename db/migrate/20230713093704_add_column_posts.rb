class AddColumnPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :likes_count, :integer
  end
end
