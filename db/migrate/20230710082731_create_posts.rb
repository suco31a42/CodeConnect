class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :end_user, null: false, foreign_key: { to_table: :end_users }
      t.text :body, null: false

      t.timestamps
    end
  end
end
