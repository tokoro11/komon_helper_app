# db/seeds.rb
# 本番/開発どちらでも何度でも実行できるように（idempotent）にする

team = Team.find_or_create_by!(name: "テスト高校A")

# find_or_create_by! だと「既に存在する時に block が走らない」ので、
# 本番で途中まで作られていた場合でも確実に更新できるようにする
komon = User.find_or_initialize_by(email: "komon@example.com")
komon.name = "顧問 太郎"
komon.team = team
komon.role = :komon

# バリデーション必須項目
komon.affiliation = "テスト高校バレー部"
komon.password = "password123" if komon.new_record? # 既存ユーザーなら上書きしない
komon.password_confirmation = "password123" if komon.new_record?
komon.save!

# 固定のテスト体育館（任意：残してOK）
Gym.find_or_create_by!(name: "第一体育館", area: "テスト") do |g|
  g.address = "東京都"
  g.reservation_url = ""
  g.availability_url = ""
  g.notes = "デモ用"
end

Gym.find_or_create_by!(name: "第二体育館", area: "テスト") do |g|
  g.address = "東京都"
  g.reservation_url = ""
  g.availability_url = ""
  g.notes = "デモ用"
end

# ローカルで作った体育館データを書き出したファイルを読み込む
seeds_gyms_path = Rails.root.join("db/seeds_gyms.rb")
load seeds_gyms_path if File.exist?(seeds_gyms_path)

puts "Seeded: team=#{team.id}, user=#{komon.id}, gyms=#{Gym.count}"
