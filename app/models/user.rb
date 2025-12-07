class User < ApplicationRecord
  ## -- アソシエーション --
  # 投稿・コメント・いいね
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  # コミュニティ（作成したものと参加中のもの）
  has_many :owned_communities, class_name: "Community", foreign_key: "owner_id", dependent: :destroy
  has_many :community_members, dependent: :destroy
  has_many :communities, through: :community_members
  # イベント
  has_many :organized_events, class_name: "Event", foreign_key: "organizer_id", dependent: :destroy
  has_many :participations, dependent: :destroy
  # フォロー機能
  has_many :active_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  # Active Storage（プロフィール画像）
  has_one_attached :profile_image

  ## -- スコープ --
  # ユーザーステータス別検索
  scope :active, -> { where(is_active: true) }
  scope :withdrawn, -> { where(is_active: false) }

  ## -- バリデーション --
  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }
  validates :introduction, length: { maximum: 300 }, allow_blank: true

  ## -- Devise認証 --
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  ## -- メソッド --
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def liked_by?(post)
    likes.exists?(post_id: post.id)
  end
end
