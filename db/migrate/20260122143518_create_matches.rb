class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.references :gym, null: false, foreign_key: true
      t.datetime :starts_at
      t.bigint :team_a_id
      t.bigint :team_b_id
      t.text :note

      t.timestamps
    end

    add_index :matches, :team_a_id
    add_index :matches, :team_b_id
    add_foreign_key :matches, :teams, column: :team_a_id
    add_foreign_key :matches, :teams, column: :team_b_id
  end
end
