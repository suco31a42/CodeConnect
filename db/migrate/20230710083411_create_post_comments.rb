class CreatePostComments < ActiveRecord::Migration[6.1]
  def change
    create_table :post_comments do |t|
      t.references :end_user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.string :body, null:false

      t.timestamps
    end
  end
end
