class Gym < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :match_listings, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name address]
  end
end
