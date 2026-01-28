class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :kind
      t.string :title
      t.text :body
      t.datetime :read_at
      t.references :notifiable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
