class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # チームはあとから設定OK
  belongs_to :team, optional: true

  has_many :bookings, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :match_listings, foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy
  has_many :match_applications, foreign_key: :applicant_id, inverse_of: :applicant, dependent: :destroy

  enum :role, { komon: 0, coach: 1, admin: 2 }

  validates :affiliation, presence: true, length: { maximum: 50 }

  # ✅ プロフィールフォーム用（DBには保存しない）
  attr_accessor :team_name
end
