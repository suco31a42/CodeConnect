class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :end_user, polymorphic: true 
      t.references :subject, foreign_key: true
      t.integer :action_type
      t.boolean :checked

      t.timestamps
    end
  end
end
