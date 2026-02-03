team = Team.find_or_create_by!(name: "テスト高校A")

guest = User.find_or_initialize_by(email: "komon@example.com")
if guest.new_record?
  guest.name = "顧問 太郎"
  guest.role = :komon
  guest.affiliation = "テスト高校バレー部"
  guest.team = team
  guest.password = "password123"
  guest.password_confirmation = "password123"
  guest.save!
else
  # 既存でも team が無い場合は補完
  guest.update!(
    team: team,
    role: :komon,
    affiliation: (guest.affiliation.presence || "テスト高校バレー部")
  ) if guest.team.nil?
end

puts "Seeded guest: user=#{guest.id}, team=#{team.id}"
