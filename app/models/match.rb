class Match < ApplicationRecord
  belongs_to :gym
  belongs_to :team_a, class_name: "Team", optional: true
  belongs_to :team_b, class_name: "Team", optional: true
  belongs_to :match_listing, optional: true

  # フォーム入力用（Gym保存用の仮想属性）
  attr_accessor :gym_name

  validates :gym, presence: true
  validates :starts_at, presence: true

  validate :teams_must_be_different

  # ===== 表示用 =====
  # チームが紐付いていればTeam名、なければ *_name を使う（過去データ互換）
  def team_a_display_name
    team_a&.name.presence || team_a_name.presence || "未設定"
  end

  def team_b_display_name
    team_b&.name.presence || team_b_name.presence || "未設定"
  end

  # 一覧/詳細で使えるタイトル
  def display_title
    "#{team_a_display_name} vs #{team_b_display_name}"
  end
  # =================

  private

  def teams_must_be_different
    return if team_a_id.blank? || team_b_id.blank?
    errors.add(:team_b_id, "に自分のチームは選択できません") if team_a_id == team_b_id
  end
end
