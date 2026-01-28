class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true

  enum :kind, {
    match_request_approved: 0,
    match_request_rejected: 1,
    match_application_received: 2
  }

  scope :unread, -> { where(read_at: nil) }

  def read?
    read_at.present?
  end

  def mark_as_read!
    return if read?
    update!(read_at: Time.current)
  end
end
