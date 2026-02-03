class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :gym

  # =====================
  # ステータス管理
  # =====================
  enum status: {
    pending: 0,   # 申請中
    approved: 1,  # 承認
    rejected: 2,  # 却下
    canceled: 3   # キャンセル
  }

  STATUS_LABELS = {
    "pending"  => "申請中",
    "approved" => "承認",
    "rejected" => "却下",
    "canceled" => "キャンセル"
  }.freeze

  # =====================
  # バリデーション
  # =====================
  validates :start_time, :end_time, presence: true
  validate  :end_time_after_start_time

  # =====================
  # コールバック
  # =====================
  before_validation :set_default_status, on: :create

  # =====================
  # 表示用メソッド
  # =====================

  # ステータスを日本語で返す
  def status_label
    STATUS_LABELS[status]
  end

  # 申請中か？
  def pending?
    status == "pending"
  end

  # 承認済みか？
  def approved?
    status == "approved"
  end

  # =====================
  # 権限チェック用（Controller/Viewで使える）
  # =====================

  # 本人か管理者か
  def editable_by?(user)
    user.admin? || self.user_id == user.id
  end

  private

  # =====================
  # バリデーション詳細
  # =====================
  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "は開始日時より後にしてください")
    end
  end

  # =====================
  # 初期ステータス設定
  # =====================
  def set_default_status
    self.status ||= "pending"
  end
end
