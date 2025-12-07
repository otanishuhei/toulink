# データクリア
ActiveStorage::Attachment.where(record_type: "User").destroy_all
ActiveStorage::Attachment.where(record_type: "Post").destroy_all
ActiveStorage::Attachment.where(record_type: "Community").destroy_all
Follow.destroy_all
Like.destroy_all
Comment.destroy_all
Participation.destroy_all
Event.destroy_all
CommunityMember.destroy_all
Community.destroy_all
Post.destroy_all
Tag.destroy_all
PostTag.destroy_all
Admin.destroy_all
User.destroy_all


# --- ユーザー ---
puts "Creating users..."

users = [
  { name: "さとし", email: "example1@example.com", password: "password", is_active: true, introduction: "週末まったりツーリング部のリーダーです！安全第一で楽しみましょう！" },
  { name: "あかり", email: "example2@example.com", password: "password", is_active: true, introduction: "愛車はレブル250。写真が好きで、景色のいい場所によく投稿します！" },
  { name: "ケント", email: "example3@example.com", password: "password", is_active: true, introduction: "積極的にイベントに参加します！バイク歴10年以上のベテランです。" },
  { name: "ハルカ", email: "example4@example.com", password: "password", is_active: true, introduction: "免許取り立ての初心者ライダーです！経験者の方、ぜひアドバイスください🙏" },
  { name: "裕司", email: "example5@example.com", password: "password", is_active: false, introduction: "退会済みユーザーです" }
]
users.each { |user_attrs| User.create!(user_attrs) }

satoshi = User.find_by(email: "example1@example.com")
akari = User.find_by(email: "example2@example.com")
kento = User.find_by(email: "example3@example.com")
haruka = User.find_by(email: "example4@example.com")

# --- 管理者 ---
puts "Creating admins..."
Admin.create!(email: "admin@admin.com", password: "password")

# =======================================================
# --- コミュニティ関連 (4つ作成) ---
# =======================================================
puts "Creating communities and members..."

# 1. 週末まったりツーリング部 (アクティブ)
community1 = Community.create!(
  name: "週末まったりツーリング部",
  description: "週末にゆっくり景色を楽しみながら走るコミュニティです。ペースは問いません。",
  owner: satoshi,
  is_active: true
)
CommunityMember.find_or_create_by!(community: community1, user: satoshi, role: :leader)
CommunityMember.find_or_create_by!(community: community1, user: akari, role: :member)
CommunityMember.find_or_create_by!(community: community1, user: kento, role: :member)
CommunityMember.find_or_create_by!(community: community1, user: haruka, role: :member)

# 2. 大型バイク限定・ハイペース愛好会 (アクティブ)
community2 = Community.create!(
  name: "大型バイク限定・ハイペース愛好会",
  description: "山道・高速道路メイン。ハイペース走行が好きな方限定。",
  owner: kento,
  is_active: true
)
CommunityMember.find_or_create_by!(community: community2, user: kento, role: :leader)
CommunityMember.find_or_create_by!(community: community2, user: satoshi, role: :member)

# 3. 女性ライダー限定・カフェ巡り (アクティブ)
community3 = Community.create!(
  name: "女性ライダー限定・カフェ巡り",
  description: "素敵なカフェやスイーツを求めて走ります。愛車・経験不問。",
  owner: akari,
  is_active: true
)
CommunityMember.find_or_create_by!(community: community3, user: akari, role: :leader)
CommunityMember.find_or_create_by!(community: community3, user: haruka, role: :member)

# 4. 地方支部：関西のツーリング仲間 (非アクティブ/休止)
Community.create!(
  name: "地方支部：関西のツーリング仲間 (休止中)",
  description: "関西エリアでの活動がメインのコミュニティです。",
  owner: satoshi,
  is_active: false
)

# =======================================================
# --- 投稿サンプル (13個作成) ---
# =======================================================
puts "Creating posts..."

# Satoshi (P1, P2, P11)
Post.create!(user: satoshi, title: "リーダーのおすすめ絶景ルート", body: "秋のドライブに最適な、渋滞の少ない山道です。", is_published: true)
Post.create!(user: satoshi, title: "愛車の紹介", body: "長年連れ添った相棒を紹介します。プロフィール画像も更新しました！", is_published: true)
Post.create!(user: satoshi, title: "コミュニティ運営報告", body: "今月のイベント参加率や、新しい企画について報告します。", is_published: true)

# Akari (P3, P4, P5)
Post.create!(user: akari, title: "伊豆スカイラインの夕日", body: "先日伊豆へ行ってきました！最高の景色でした✨", is_published: true)
Post.create!(user: akari, title: "【管理者非公開テスト】初心者向け練習会のお知らせ", body: "【管理者非公開テスト】コミュニティ3で開催予定です。詳細はイベントページで確認を!", is_published: false)
Post.create!(user: akari, title: "お気に入りの道の駅", body: "地元の美味しいものがたくさん！休憩にも最適です。", is_published: true)

# Kento (P6, P7, P8, P12)
Post.create!(user: kento, title: "富士山周遊ソロツーリング", body: "気温が低かったですが、空気も澄んでいて最高でした！", is_published: true)
Post.create!(user: kento, title: "【ユーザー削除テスト】高速道路での注意点", body: "【ユーザー削除テスト】ハイペース走行時の風対策について。ベテランの経験談です。", is_published: true, is_deleted: true)
Post.create!(user: kento, title: "バイク用品のレビュー", body: "新しく買ったヘルメットのレビューです。", is_published: true)
Post.create!(user: kento, title: "冬の防寒対策！電熱ウェアレビュー", body: "寒さが厳しくなってきたので、電熱ウェアの導入レビューを共有します。", is_published: true)

# Haruka (P9, P10, P13)
Post.create!(user: haruka, title: "初めての長距離！", body: "休憩しながらですが、無事に往復できました！次はもっと遠くへ行きたいです。", is_published: true)
Post.create!(user: haruka, title: "バイクのメンテナンス相談", body: "チェーン掃除って難しいですね...皆さんはどんなツールを使っていますか？", is_published: true)
Post.create!(user: haruka, title: "【初カスタム】スマホホルダーをつけました！", body: "やっとスマホホルダーを装着しました！これでナビも見やすくなります。", is_published: true)

posts = Post.all.to_a
post_satoshi_1 = posts[0] # P1
post_satoshi_2 = posts[1] # P2
post_satoshi_3 = posts[2] # P11
post_akari_1 = posts[3] # P3
post_akari_2 = posts[4] # P4
post_akari_3 = posts[5] # P5
post_kento_1 = posts[6] # P6
post_kento_2 = posts[7] # P7
post_kento_3 = posts[8] # P8
post_kento_4 = posts[9] # P12
post_haruka_1 = posts[10] # P9
post_haruka_2 = posts[11] # P10
post_haruka_3 = posts[12] # P13


# =======================================================
# --- フォロー機能 ---
# =======================================================
puts "Creating follows..."
Follow.create!(follower: satoshi, followed: kento)
Follow.create!(follower: akari, followed: kento)
Follow.create!(follower: akari, followed: satoshi)
Follow.create!(follower: haruka, followed: satoshi)
Follow.create!(follower: haruka, followed: akari)
Follow.create!(follower: haruka, followed: kento)

# =======================================================
# --- いいね機能 ---
# =======================================================
puts "Creating likes..."
# P3
Like.create!(user: satoshi, post: post_akari_1)
Like.create!(user: kento, post: post_akari_1)
Like.create!(user: haruka, post: post_akari_1)
# P6
Like.create!(user: satoshi, post: post_kento_1)
# P1
Like.create!(user: akari, post: post_satoshi_1)
# P9
Like.create!(user: akari, post: post_haruka_1)
Like.create!(user: kento, post: post_haruka_1)
# P11
Like.create!(user: kento, post: post_satoshi_3)
# P12
Like.create!(user: satoshi, post: post_kento_4)
Like.create!(user: akari, post: post_kento_4)
# P13
Like.create!(user: satoshi, post: post_haruka_3)
Like.create!(user: akari, post: post_haruka_3)


# =======================================================
# --- コメント機能 ---
# =======================================================
puts "Creating comments..."

# P1: リーダーのおすすめ絶景ルート (Satoshi)
Comment.create!(user: akari, post: post_satoshi_1, body: "ぜひ走ってみたいです！地図を参考にさせていただきますね。", is_published: true)
Comment.create!(user: kento, post: post_satoshi_1, body: "【管理者非公開テスト】非公開コメントです。", is_published: false)
Comment.create!(user: haruka, post: post_satoshi_1, body: "【ユーザー削除テスト】削除されたコメントです。", is_published: true, is_deleted: true)

# P2: 愛車の紹介 (Satoshi)
Comment.create!(user: akari, post: post_satoshi_2, body: "かっこいいバイクですね！写真もプロみたいに綺麗です。", is_published: true)
Comment.create!(user: haruka, post: post_satoshi_2, body: "私もSatoshiさんのバイク、いつか乗ってみたいです！", is_published: true)

# P3: 伊豆スカイラインの夕日 (Akari)
Comment.create!(user: satoshi, post: post_akari_1, body: "絶景ですね！この場所の近くでイベントを企画しましょうか！", is_published: true)
Comment.create!(user: kento, post: post_akari_1, body: "私もここに行ったことがあります！また走りに行きたいです。", is_published: true)
Comment.create!(user: haruka, post: post_akari_1, body: "初心者でも走りやすい道ですか？参考にしたいです！", is_published: true)

# P4: 初心者向け練習会のお知らせ (Akari)
Comment.create!(user: kento, post: post_akari_2, body: "初心者向けイベント、素晴らしい取り組みですね！当日、お手伝いできることがあれば声をかけてください。", is_published: true)
Comment.create!(user: haruka, post: post_akari_2, body: "絶対参加したいです！ありがとうございます！", is_published: true)

# P5: お気に入りの道の駅 (Akari)
Comment.create!(user: satoshi, post: post_akari_3, body: "この道の駅、週末ツーリングの集合場所に良さそうですね！", is_published: true)
Comment.create!(user: kento, post: post_akari_3, body: "そこのお土産、美味しいですよね！", is_published: true)

# P6: 富士山周遊ソロツーリング (Kento)
Comment.create!(user: satoshi, post: post_kento_1, body: "迫力あるライディングフォト、最高ですね！", is_published: true)
Comment.create!(user: haruka, post: post_kento_1, body: "富士山がこんなに大きく見えるんですね！感動しました！", is_published: true)

# P7: 高速道路での注意点 (Kento)
Comment.create!(user: satoshi, post: post_kento_2, body: "ベテランならではの貴重な情報、ありがとうございます。コミュニティ内で共有させていただきます。", is_published: true)

# P8: バイク用品のレビュー (Kento)
Comment.create!(user: akari, post: post_kento_3, body: "私も色違いを持っています！長距離でも疲れにくいですよね。", is_published: true)

# P9: 初めての長距離！ (Haruka)
Comment.create!(user: satoshi, post: post_haruka_1, body: "長距離デビューおめでとうございます！無理せず楽しんでくださいね。", is_published: true)
Comment.create!(user: kento, post: post_haruka_1, body: "無事帰宅が一番大事です！だんだん走るのが楽しくなりますよ！", is_published: true)

# P10: バイクのメンテナンス相談 (Haruka)
Comment.create!(user: kento, post: post_haruka_2, body: "チェーン掃除は最初は大変ですよね。私は〇〇というクリーナーを使っていますよ。", is_published: true)
Comment.create!(user: akari, post: post_haruka_2, body: "動画を見ながらやると分かりやすいですよ！", is_published: true)

# P11: コミュニティ運営報告 (Satoshi)
Comment.create!(user: kento, post: post_satoshi_3, body: "リーダー、いつもありがとうございます！イベント企画楽しみにしています！", is_published: true)
Comment.create!(user: haruka, post: post_satoshi_3, body: "皆さんの活動に感謝です！", is_published: true)

# P12: 冬の防寒対策！電熱ウェアレビュー (Kento)
Comment.create!(user: satoshi, post: post_kento_4, body: "真冬のツーリングには必須ですよね。非常に参考になりました。", is_published: true)
Comment.create!(user: akari, post: post_kento_4, body: "私も買おうか迷っていたので、レビュー助かります！", is_published: true)

# P13: 【初カスタム】スマホホルダーをつけました！ (Haruka)
Comment.create!(user: satoshi, post: post_haruka_3, body: "カスタムデビューおめでとう！どんどん愛車をいじっていくのも楽しいですよ😊", is_published: true)
Comment.create!(user: kento, post: post_haruka_3, body: "ナビが視界に入ると安心感が違いますよね。良いカスタムです！", is_published: true)


# =======================================================
# --- イベント関連 ---
# =======================================================
puts "Creating events and participations..."

# 1. 募集中のイベント (community1主催)
event1 = Event.create!(
  community: community1,
  organizer: satoshi,
  title: "初夏の絶景カフェツーリング",
  description: "山頂の絶景カフェを目指して、午前中まったり走ります。\n初心者大歓迎です。",
  meeting_place: "中央道 石川PA",
  destination: "山梨 絶景カフェ",
  start_at: Time.current.next_day(7).beginning_of_hour + 9.hours,
  max_participants: 5,
  pace_required: :pace_average,
  status: :recruiting,
  is_deleted: false
)

# 参加情報
Participation.create!(event: event1, user: akari, status: :confirmed)
Participation.create!(event: event1, user: kento, status: :pending)
Participation.create!(event: event1, user: haruka, status: :confirmed)

# 2. 大型バイク限定イベント (community2主催)
Event.create!(
  community: community2,
  organizer: kento,
  title: "【ハイペース】大型限定！箱根の峠道チャレンジ",
  description: "経験者向けのイベントです。",
  meeting_place: "東名高速 港北PA",
  destination: "箱根ターンパイク",
  start_at: Time.current.next_day(14).beginning_of_hour + 7.hours,
  max_participants: 3,
  pace_required: :pace_fast,
  status: :recruiting,
  is_deleted: false
)
# Satoshiが参加確定
Participation.create!(event: Event.last, user: satoshi, status: :confirmed)


# 3. 満席のイベント
event3 = Event.create!(
  community: community1,
  organizer: akari,
  title: "【満席】初心者向け練習走行会",
  description: "基礎練習のための広場での走行会です。",
  meeting_place: "河川敷広場",
  destination: "なし",
  start_at: Time.current.next_day(10).beginning_of_hour + 14.hours,
  max_participants: 1,
  pace_required: :pace_slow,
  status: :closed,
  is_deleted: false
)
Participation.create!(event: event3, user: kento, status: :confirmed)


puts "Seed data creation complete!"
