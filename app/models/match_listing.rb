class MatchListing < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :gym

  has_many :match_applications, dependent: :destroy
  has_one :match, dependent: :destroy

  # フォーム入力用（Gym保存用の仮想属性）
  attr_accessor :gym_name, :gym_address

  enum :gender_category, { boys: 0, girls: 1 }
  enum :school_category, { junior_high: 0, high_school: 1, university: 2 }
  enum :status, { open: 0, closed: 1, canceled: 2 }

  validates :match_date, :start_time, :end_time, :gender_category, :school_category, :status, presence: true
  validate :end_time_after_start_time

  # ===== Ransack allowlist（検索・絞り込み用）=====
  def self.ransackable_attributes(auth_object = nil)
    %w[
      match_date start_time end_time
      gender_category school_category status
      gym_id
      created_at updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[gym]
  end
  # ===============================================

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?
    errors.add(:end_time, "は開始時間より後にしてください") if end_time <= start_time
  end
end
