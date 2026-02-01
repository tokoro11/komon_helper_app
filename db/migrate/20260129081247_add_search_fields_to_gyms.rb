class AddSearchFieldsToGyms < ActiveRecord::Migration[7.2]
  def change
    add_column :gyms, :area, :string
    add_column :gyms, :reservation_url, :string
    add_column :gyms, :availability_url, :string
    add_column :gyms, :notes, :text
  end
end
