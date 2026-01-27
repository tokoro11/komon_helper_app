class AddUniqueIndexToMatchApplications < ActiveRecord::Migration[7.1]
  def change
    add_index :match_applications,
              [:applicant_id, :match_listing_id],
              unique: true,
              name: "index_match_apps_on_applicant_and_listing"
  end
end
