class CreateMatchListings < ActiveRecord::Migration[7.0]
  def change
    create_table :match_listings do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.references :gym, null: false, foreign_key: true

      t.date :match_date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.integer :gender_category, null: false
      t.integer :school_category, null: false
      t.integer :status, null: false, default: 0

      t.text :notes

      t.timestamps
    end
  end
end
