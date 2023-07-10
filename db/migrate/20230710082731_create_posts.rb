class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :end_user, null: false, foreign_key: true
      t.string :body

      t.timestamps
    end
  end
end
