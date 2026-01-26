class ChangeMatchListingIdNullOnMatches < ActiveRecord::Migration[7.0]
  def change
    change_column_null :matches, :match_listing_id, true
  end
end
