class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.references :end_user, foreign_key: true
      t.references :post

      t.timestamps
    end
  end
end
