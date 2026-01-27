class Match < ApplicationRecord
  belongs_to :gym
  belongs_to :team_a, class_name: "Team", optional: true
  belongs_to :team_b, class_name: "Team", optional: true

  belongs_to :match_listing, optional: true

  attr_accessor :gym_name

  validate :teams_must_be_different

  private

  def teams_must_be_different
    return if team_a_id.blank? || team_b_id.blank?
    return unless team_a_id == team_b_id

    errors.add(:team_b_id, "に自分のチームは選択できません")
  end
end
