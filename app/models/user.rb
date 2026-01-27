class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :team, optional: true
  has_many :bookings, dependent: :destroy

  enum :role, { komon: 0, coach: 1, admin: 2 }
  validates :affiliation, presence: true, length: { maximum: 50 }
end
