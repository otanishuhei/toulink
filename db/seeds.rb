# db/seeds.rb

# --- ユーザー ---
User.destroy_all # 既存データを消す場合（開発環境用）
puts "Creating users..."

users = [
  { name: "leader", email: "leader@example.com", password: "password", is_active: true, introduction: "コミュニティのリーダーです。ツーリング大好き！" },
  { name: "memberA", email: "membera@example.com", password: "password", is_active: true, introduction: "まったりツーリング派" },
  { name: "memberB", email: "memberb@example.com", password: "password", is_active: true, introduction: "積極的にイベントに参加します" },
  { name: "retiredUser", email: "retired@example.com", password: "password", is_active: false, introduction: "退会済みユーザーです" }
]

users.each do |user_attrs|
  User.create!(user_attrs)
end

puts "#{User.count} users created."

# 必要なユーザーを取得
leader = User.find_by(email: "leader@example.com")
member_a = User.find_by(email: "membera@example.com")
member_b = User.find_by(email: "memberb@example.com")

# --- 管理者 ---
Admin.destroy_all
puts "Creating admins..."

admins = [
  { email: "admin@admin.com", password: "password" }
]

admins.each do |admin_attrs|
  Admin.create!(admin_attrs)
end

puts "#{Admin.count} admins created."

# --- 投稿サンプル ---
Post.destroy_all
puts "Creating posts..."

User.all.each do |user|
  3.times do |i|
    Post.create!(
      user: user,
      title: "#{user.name}の投稿#{i + 1}",
      body: "これは#{user.name}のサンプル投稿です。",
      is_published: true,
      is_deleted: false
    )
  end
end

puts "#{Post.count} posts created."

# =======================================================
# --- コミュニティ関連 (追加) ---
# =======================================================
Community.destroy_all
CommunityMember.destroy_all
puts "Creating communities and members..."

# --- 1. アクティブなコミュニティ (リーダー: Leader) ---
community1 = Community.create!(
  name: "週末まったりツーリング部",
  description: "週末にゆっくり景色を楽しみながら走るコミュニティです。ペースは問いません。",
  owner: leader,
  is_active: true
)

# CommunityMember が存在しない場合、またはロールが間違っている場合に作成/更新
CommunityMember.find_or_create_by!(community: community1, user: leader) do |cm|
  cm.role = :leader # ロールをリーダーとして設定
end
# メンバーAとBの登録
CommunityMember.find_or_create_by!(community: community1, user: member_a, role: :member)
CommunityMember.find_or_create_by!(community: community1, user: member_b, role: :member)

# --- 2. 非アクティブなコミュニティ ---
Community.create!(
  name: "高速走行愛好会 (休止中)",
  description: "現在は活動休止中のコミュニティです。",
  owner: member_a,
  is_active: false
)

puts "#{Community.count} communities created."
puts "#{CommunityMember.count} community members created."

# =======================================================
# --- イベント関連 (追加) ---
# =======================================================
Event.destroy_all
Participation.destroy_all
puts "Creating events and participations..."

# --- 1. 募集中のイベント (参加者あり) ---
event1 = Event.create!(
  community: community1,
  organizer: leader,
  title: "初夏の絶景カフェツーリング",
  description: "山頂の絶景カフェを目指して、午前中まったり走ります。\n初心者大歓迎です。",
  meeting_place: "中央道 石川PA",
  destination: "山梨 絶景カフェ",
  start_at: Time.current.next_day(7).beginning_of_hour + 9.hours, # 来週の土曜 9:00
  max_participants: 5,
  pace_required: :pace_average,
  status: :recruiting,
  is_deleted: false
)

# 参加情報
# メンバーA: 承認済み (confirmed)
Participation.create!(event: event1, user: member_a, status: :confirmed)
# メンバーB: 申請中 (pending)
Participation.create!(event: event1, user: member_b, status: :pending)

# --- 2. 企画中のイベント (主催者のみ閲覧可能) ---
Event.create!(
  community: community1,
  organizer: leader,
  title: "【企画中】秋の紅葉狩りツーリング",
  description: "まだ詳細は未定ですが、人気の紅葉スポットへ行く予定です。",
  meeting_place: "未定",
  destination: "紅葉スポット",
  start_at: Time.current.next_day(30).beginning_of_hour + 10.hours, # 来月
  max_participants: nil,
  pace_required: :pace_any,
  status: :draft, # 企画中
  is_deleted: false
)

# --- 3. 満席のイベント ---
event3 = Event.create!(
  community: community1,
  organizer: member_a,
  title: "【満席】初心者向け練習走行会",
  description: "基礎練習のための広場での走行会です。",
  meeting_place: "河川敷広場",
  destination: "なし",
  start_at: Time.current.next_day(10).beginning_of_hour + 14.hours,
  max_participants: 1,
  pace_required: :pace_slow,
  status: :recruiting,
  is_deleted: false
)
# 満席にするため、メンバーBを承認済みに
Participation.create!(event: event3, user: member_b, status: :confirmed)
# ※主催者(member_a)自身は参加者リストに入れない設計を前提としています

puts "#{Event.count} events created."
puts "#{Participation.count} participations created."
puts "Seed data creation complete! 🎉"
