class CreateMatchApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :match_applications do |t|
      t.references :match_listing, null: false, foreign_key: true
      t.references :applicant, null: false, foreign_key: { to_table: :users }
      t.integer :status, null: false, default: 0
      t.text :message

      t.timestamps
    end
  end
end
