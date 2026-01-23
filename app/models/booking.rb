class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :gym

  enum status: { pending: 0, approved: 1, rejected: 2, canceled: 3 }

  STATUS_LABELS = {
    pending: "申請中",
    approved: "承認",
    rejected: "却下",
    canceled: "キャンセル"
  }
end
