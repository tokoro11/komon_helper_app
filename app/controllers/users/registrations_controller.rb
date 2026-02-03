class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      next unless user.persisted?

      team_name = normalize(params.dig(:user, :team_name))
      next if team_name.blank?

      team = Team.find_or_create_by!(name: team_name)
      user.update!(team: team)
    end
  end

  private

  def normalize(value)
    value.to_s.tr("　", " ").strip
  end
end
