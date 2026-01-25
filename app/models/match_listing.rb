class MatchListing < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :gym

  enum gender_category: { boys: 0, girls: 1 }
  enum school_category: { junior_high: 0, high_school: 1, university: 2 }
  enum status: { open: 0, closed: 1, canceled: 2 }

  validates :match_date, :start_time, :end_time, :gender_category, :school_category, :status, presence: true
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?
    errors.add(:end_time, "は開始時間より後にしてください") if end_time <= start_time
  end
end
