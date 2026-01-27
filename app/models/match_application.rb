class MatchApplication < ApplicationRecord
  belongs_to :match_listing
  belongs_to :applicant, class_name: "User"

  enum :status, { pending: 0, approved: 1, rejected: 2, canceled: 3 }

  validates :status, presence: true
  validates :applicant_id, uniqueness: { scope: :match_listing_id, message: "はこの募集に既に申請済みです" }
end
