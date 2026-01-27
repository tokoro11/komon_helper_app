class AddTeamNamesToMatches < ActiveRecord::Migration[7.2]
  def change
    add_column :matches, :team_a_name, :string
    add_column :matches, :team_b_name, :string
  end
end
