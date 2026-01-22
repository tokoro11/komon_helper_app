# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
team = Team.find_or_create_by!(name: "テスト高校A")

komon = User.find_or_create_by!(email: "komon@example.com") do |u|
  u.name = "顧問 太郎"
  u.team = team
  u.role = :komon
end

Gym.find_or_create_by!(name: "第一体育館") { |g| g.address = "東京都" }
Gym.find_or_create_by!(name: "第二体育館") { |g| g.address = "東京都" }

puts "Seeded: team=#{team.id}, user=#{komon.id}, gyms=#{Gym.count}"
