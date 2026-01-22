class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :gym

  enum status: { pending: 0, approved: 1, rejected: 2, canceled: 3 }
end
