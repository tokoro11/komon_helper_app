class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.integer :role

      t.timestamps
    end
  end
end
