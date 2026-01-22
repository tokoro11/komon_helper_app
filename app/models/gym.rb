class Gym < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :matches, dependent: :destroy
end
