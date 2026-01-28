class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :team, optional: true

  has_many :bookings, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # ✅ 自分が募集した練習試合募集（match_listings.owner_id）
  has_many :match_listings, foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy

  # ✅ 自分が出した申請（match_applications.applicant_id）
  has_many :match_applications, foreign_key: :applicant_id, inverse_of: :applicant, dependent: :destroy

  enum :role, { komon: 0, coach: 1, admin: 2 }

  validates :affiliation, presence: true, length: { maximum: 50 }
end
