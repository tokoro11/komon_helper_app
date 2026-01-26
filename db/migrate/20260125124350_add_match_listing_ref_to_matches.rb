class AddMatchListingRefToMatches < ActiveRecord::Migration[7.1]
  def change
    add_reference :matches, :match_listing, null: false, foreign_key: true, index: { unique: true }
  end
end
