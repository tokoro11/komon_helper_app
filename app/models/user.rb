class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # =====================
  # Associations
  # =====================
  belongs_to :team, optional: true

  has_many :bookings, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :match_listings, foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy
  has_many :match_applications, foreign_key: :applicant_id, inverse_of: :applicant, dependent: :destroy

  # =====================
  # Enums
  # =====================
  enum :role, { komon: 0, coach: 1, admin: 2 }

  # =====================
  # Virtual attributes
  # =====================
  # Sign up / profile form 用（DBには保存しない）
  attr_accessor :team_name

  # =====================
  # Validations
  # =====================
  validates :name, presence: true, length: { maximum: 30 }, on: :create
  validates :affiliation, presence: true, length: { maximum: 50 }, on: :create
  validates :team_name, presence: true, on: :create

  # もし「プロフィール編集でも affiliation は必須」にしたいなら、上の on: :create を外して↓にする：
  # validates :affiliation, presence: true, length: { maximum: 50 }
end
