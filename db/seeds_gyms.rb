Gym.find_or_create_by!(name: "第一体育館", area: "新宿区") do |gym|
  gym.address = "東京都"
  gym.reservation_url = "https://example.com"
  gym.availability_url = nil
  gym.notes = "団体登録が必要"
end
Gym.find_or_create_by!(name: "第二体育館", area: nil) do |gym|
  gym.address = "東京都"
  gym.reservation_url = nil
  gym.availability_url = nil
  gym.notes = nil
end
Gym.find_or_create_by!(name: "関東国際", area: nil) do |gym|
  gym.address = "東京都渋谷区本町三丁目"
  gym.reservation_url = nil
  gym.availability_url = nil
  gym.notes = nil
end
Gym.find_or_create_by!(name: "関東国際１", area: nil) do |gym|
  gym.address = "東京都渋谷区"
  gym.reservation_url = nil
  gym.availability_url = nil
  gym.notes = nil
end
Gym.find_or_create_by!(name: "関東国際体育館", area: nil) do |gym|
  gym.address = "東京"
  gym.reservation_url = nil
  gym.availability_url = nil
  gym.notes = nil
end
Gym.find_or_create_by!(name: "成城高校体育館", area: nil) do |gym|
  gym.address = nil
  gym.reservation_url = nil
  gym.availability_url = nil
  gym.notes = nil
end
Gym.find_or_create_by!(name: "開成高校体育館", area: nil) do |gym|
  gym.address = nil
  gym.reservation_url = nil
  gym.availability_url = nil
  gym.notes = nil
end
Gym.find_or_create_by!(name: "東京都渋谷区本町三丁目関東国際高校体育館", area: nil) do |gym|
  gym.address = "東京都渋谷区本町三丁目"
  gym.reservation_url = nil
  gym.availability_url = nil
  gym.notes = nil
end
Gym.find_or_create_by!(name: "駿台高校体育館", area: nil) do |gym|
  gym.address = "〒114-0002 東京都北区王子６丁目１−１０"
  gym.reservation_url = nil
  gym.availability_url = nil
  gym.notes = nil
end
Gym.find_or_create_by!(name: "上智大学", area: nil) do |gym|
  gym.address = "東京都四谷"
  gym.reservation_url = nil
  gym.availability_url = nil
  gym.notes = nil
end
Gym.find_or_create_by!(name: "東亜高校体育館", area: nil) do |gym|
  gym.address = "〒114-0002 東京都北区王子６丁目１−１０"
  gym.reservation_url = nil
  gym.availability_url = nil
  gym.notes = nil
end
Gym.find_or_create_by!(name: "新宿スポーツセンター", area: "新宿区") do |gym|
  gym.address = "東京都新宿区大久保3-5-1"
  gym.reservation_url = "https://www.shinjuku.eprs.jp/regasu/web/"
  gym.availability_url = "https://www.shinjuku.eprs.jp/regasu/web/"
  gym.notes = "団体利用は抽選/ネット申込。曜日など条件あり。"
end
Gym.find_or_create_by!(name: "ひがしんアリーナ（墨田区総合体育館）", area: "墨田区") do |gym|
  gym.address = "東京都墨田区錦糸4-15-1"
  gym.reservation_url = "https://yoyaku.sumidacity-gym.com/"
  gym.availability_url = "https://yoyaku.sumidacity-gym.com/"
  gym.notes = "利用者登録が必要（予約システムに案内あり）。"
end
Gym.find_or_create_by!(name: "深川スポーツセンター", area: "江東区") do |gym|
  gym.address = "東京都江東区越中島1-2-18"
  gym.reservation_url = "https://yoyaku.koto-sports.net/koto_v2/reserve/gin_menu"
  gym.availability_url = "https://yoyaku.koto-sports.net/koto_v2/reserve/gin_menu"
  gym.notes = "体育施設予約システム。利用者登録が必要。"
end
Gym.find_or_create_by!(name: "文京総合体育館", area: "文京区") do |gym|
  gym.address = "東京都文京区本郷7-1-2"
  gym.reservation_url = "https://www.shisetsu.city.bunkyo.lg.jp/user/Home"
  gym.availability_url = "https://www.shisetsu.city.bunkyo.lg.jp/user/Home"
  gym.notes = "『文の京』施設予約ねっと。スポーツ施設の申請はスポーツセンターで受付。"
end
Gym.find_or_create_by!(name: "港区スポーツセンター", area: "港区") do |gym|
  gym.address = "東京都港区芝浦1-16-1（みなとパーク芝浦内）"
  gym.reservation_url = "https://web101.rsv.ws-scs.jp/web/"
  gym.availability_url = "https://web101.rsv.ws-scs.jp/web/"
  gym.notes = "港区施設予約システム。空き照会はログインなし可、申込は登録後。"
end
Gym.find_or_create_by!(name: "千代田区スポーツセンター", area: "千代田区") do |gym|
  gym.address = "東京都千代田区"
  gym.reservation_url = "https://www.spst-chiyoda.jp/reserve/login.aspx"
  gym.availability_url = "https://www.spst-chiyoda.jp/reserve/login.aspx"
  gym.notes = "千代田区立スポーツセンター。団体利用は登録が必要。"
end
Gym.find_or_create_by!(name: "中央区立総合スポーツセンター", area: "中央区") do |gym|
  gym.address = "東京都中央区日本橋浜町2丁目59-1"
  gym.reservation_url = "https://chuo-yoyaku.openreaf02.jp/"
  gym.availability_url = "https://chuo-yoyaku.openreaf02.jp/"
  gym.notes = "中央区の公共施設予約システム。"
end
Gym.find_or_create_by!(name: "港区スポーツセンター", area: "港区") do |gym|
  gym.address = "東京都港区芝浦1-16-1"
  gym.reservation_url = "https://www.city.minato.tokyo.jp/jouhoseisaku/shisetuyoyaku-riyou.html"
  gym.availability_url = "https://www.city.minato.tokyo.jp/jouhoseisaku/shisetuyoyaku-riyou.html"
  gym.notes = "港区施設予約システムから空き確認・申込可能。"
end
Gym.find_or_create_by!(name: "新宿スポーツセンター", area: "新宿区") do |gym|
  gym.address = "東京都新宿区大久保3-5-1"
  gym.reservation_url = "https://www.shinjuku.eprs.jp/regasu/web/"
  gym.availability_url = "https://www.shinjuku.eprs.jp/regasu/web/"
  gym.notes = "新宿区立スポーツセンター。"
end
Gym.find_or_create_by!(name: "渋谷区スポーツセンター", area: "渋谷区") do |gym|
  gym.address = "東京都渋谷区西原1-42-1"
  gym.reservation_url = "https://www.city.shibuya.tokyo.jp/outline/guide/sports.html"
  gym.availability_url = "https://www.city.shibuya.tokyo.jp/outline/guide/sports.html"
  gym.notes = "渋谷区総合スポーツ施設。"
end
Gym.find_or_create_by!(name: "豊島区立総合体育館", area: "豊島区") do |gym|
  gym.address = "東京都豊島区"
  gym.reservation_url = "https://www.11489.jp/??"
  gym.availability_url = "https://www.11489.jp/??"
  gym.notes = "豊島区の公共施設予約システム入口（代表）。"
end
Gym.find_or_create_by!(name: "目黒区立中央体育館", area: "目黒区") do |gym|
  gym.address = "東京都目黒区"
  gym.reservation_url = "https://resv.city.meguro.tokyo.jp/Web/Home/WgR_ModeSelect"
  gym.availability_url = "https://resv.city.meguro.tokyo.jp/Web/Home/WgR_ModeSelect"
  gym.notes = "目黒区の施設予約システム入口。"
end
Gym.find_or_create_by!(name: "江東区総合体育館", area: "江東区") do |gym|
  gym.address = "東京都江東区"
  gym.reservation_url = "https://yoyaku.koto-sports.net/koto_v2/reserve/gin_menu"
  gym.availability_url = "https://yoyaku.koto-sports.net/koto_v2/reserve/gin_menu"
  gym.notes = "江東区の施設予約入口。"
end
Gym.find_or_create_by!(name: "墨田区ひがしんアリーナ", area: "墨田区") do |gym|
  gym.address = "東京都墨田区錦糸4-15-1"
  gym.reservation_url = "https://yoyaku.sumidacity-gym.com/"
  gym.availability_url = "https://yoyaku.sumidacity-gym.com/"
  gym.notes = "墨田区総合体育館。”ひがしんアリーナ”"
end
Gym.find_or_create_by!(name: "板橋区立グリーンホール体育館", area: "板橋区") do |gym|
  gym.address = "東京都板橋区"
  gym.reservation_url = "https://www.itabashi-shisetsu-yoyaku.jp/"
  gym.availability_url = "https://www.itabashi-shisetsu-yoyaku.jp/"
  gym.notes = "板橋区公共施設予約入口。"
end
Gym.find_or_create_by!(name: "北区赤羽体育館", area: "北区") do |gym|
  gym.address = "東京都北区"
  gym.reservation_url = "https://www.city.kita.lg.jp/culture-tourism-sports/sports/1010385/1010387/1010416/??"
  gym.availability_url = "https://www.city.kita.lg.jp/culture-tourism-sports/sports/1010385/1010387/1010416/??"
  gym.notes = "北区赤羽体育館ページ（空きは区予約システム）。"
end
Gym.find_or_create_by!(name: "江戸川区総合体育館", area: "江戸川区") do |gym|
  gym.address = "東京都江戸川区"
  gym.reservation_url = "https://www.shisetsuyoyaku.city.edogawa.tokyo.jp/user/Home"
  gym.availability_url = "https://www.shisetsuyoyaku.city.edogawa.tokyo.jp/user/Home"
  gym.notes = "江戸川区公共施設予約システム。"
end
Gym.find_or_create_by!(name: "練馬区体育館", area: "練馬区") do |gym|
  gym.address = "東京都練馬区"
  gym.reservation_url = "https://yoyaku.city.nerima.tokyo.jp/stagia/reserve/gin_menu"
  gym.availability_url = "https://yoyaku.city.nerima.tokyo.jp/stagia/reserve/gin_menu"
  gym.notes = "練馬区施設予約入口。"
end
Gym.find_or_create_by!(name: "世田谷区立総合体育館", area: "世田谷区") do |gym|
  gym.address = "東京都世田谷区"
  gym.reservation_url = "https://se-sports.or.jp/facilityinfo/sougou-gym/"
  gym.availability_url = "https://se-sports.or.jp/facilityinfo/sougou-gym/"
  gym.notes = "世田谷区スポーツ施設。"
end
Gym.find_or_create_by!(name: "杉並区スポーツセンター", area: "杉並区") do |gym|
  gym.address = "東京都杉並区"
  gym.reservation_url = "https://www.suginami-sports.jp/??"
  gym.availability_url = "https://www.suginami-sports.jp/??"
  gym.notes = "杉並区スポーツセンター（公式案内）。"
end
Gym.find_or_create_by!(name: "文京区体育施設", area: "文京区") do |gym|
  gym.address = "東京都文京区"
  gym.reservation_url = "https://www.shisetsu.city.bunkyo.lg.jp/user/Home"
  gym.availability_url = "https://www.shisetsu.city.bunkyo.lg.jp/user/Home"
  gym.notes = "文京区『文の京』施設予約入口。"
end
Gym.find_or_create_by!(name: "台東区スポーツセンター", area: "台東区") do |gym|
  gym.address = "東京都台東区"
  gym.reservation_url = "https://www.city.taito.lg.jp/index/??"
  gym.availability_url = "https://www.city.taito.lg.jp/index/??"
  gym.notes = "台東区スポーツセンター（区公式）。"
end
Gym.find_or_create_by!(name: "豊島区池袋体育館", area: "豊島区") do |gym|
  gym.address = "東京都豊島区"
  gym.reservation_url = "https://www.11489.jp/??"
  gym.availability_url = "https://www.11489.jp/??"
  gym.notes = "豊島区の代表体育館。"
end
Gym.find_or_create_by!(name: "目黒区立駒場体育館", area: "目黒区") do |gym|
  gym.address = "東京都目黒区"
  gym.reservation_url = "https://resv.city.meguro.tokyo.jp/Web/Home/WgR_ModeSelect"
  gym.availability_url = "https://resv.city.meguro.tokyo.jp/Web/Home/WgR_ModeSelect"
  gym.notes = "目黒区体育館（団体申込は施設予約システム）。"
end
Gym.find_or_create_by!(name: "大田区総合体育館", area: "大田区") do |gym|
  gym.address = "東京都大田区"
  gym.reservation_url = "https://www.yoyaku.city.ota.tokyo.jp/"
  gym.availability_url = "https://www.yoyaku.city.ota.tokyo.jp/"
  gym.notes = "大田区公共施設予約。"
end
Gym.find_or_create_by!(name: "品川区体育館", area: "品川区") do |gym|
  gym.address = "東京都品川区"
  gym.reservation_url = "https://www.yoyaku.city.shinagawa.tokyo.jp/"
  gym.availability_url = "https://www.yoyaku.city.shinagawa.tokyo.jp/"
  gym.notes = "品川区施設予約入口。"
end
Gym.find_or_create_by!(name: "目黒区立中根体育館", area: "目黒区") do |gym|
  gym.address = "東京都目黒区"
  gym.reservation_url = "https://resv.city.meguro.tokyo.jp/Web/Home/WgR_ModeSelect"
  gym.availability_url = "https://resv.city.meguro.tokyo.jp/Web/Home/WgR_ModeSelect"
  gym.notes = "中根体育館（目黒区予約システム）。"
end
Gym.find_or_create_by!(name: "板橋区立体育館", area: "板橋区") do |gym|
  gym.address = "東京都板橋区"
  gym.reservation_url = "https://www.itabashi-shisetsu-yoyaku.jp/"
  gym.availability_url = "https://www.itabashi-shisetsu-yoyaku.jp/"
  gym.notes = "板橋区の公共体育館。"
end
