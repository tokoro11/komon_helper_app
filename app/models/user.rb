class User < ApplicationRecord
  belongs_to :team, optional: true
  has_many :bookings, dependent: :destroy

  enum :role, { komon: 0, coach: 1, admin: 2 }
end
