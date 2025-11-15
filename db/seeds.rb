# db/seeds.rb

# --- ユーザー ---
User.destroy_all # 既存データを消す場合（開発環境用）
puts "Creating users..."

users = [
  { name: "example", email: "example@example.com", password: "example", is_active: true, introduction: "ツーリング大好きです" },
  { name: "example2", email: "example2@example.com", password: "example", is_active: true, introduction: "まったりツーリング派" },
  { name: "retireduser", email: "retired@example.com", password: "password", is_active: false, introduction: "退会済みユーザーです" }
]

users.each do |user_attrs|
  User.create!(user_attrs)
end

puts "#{User.count} users created."

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
