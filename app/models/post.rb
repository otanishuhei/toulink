class Post < ApplicationRecord
  ## -- アソシエーション --
  # 投稿者
  belongs_to :user
  # コメント
  has_many :comments, dependent: :destroy
  # いいね
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  # タグ
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  # Active Storage（投稿画像）
  has_one_attached :post_image

  ## -- スコープ --
  # 投稿ステータス別検索
  scope :published, -> { where(is_published: true, is_deleted: false) }
  scope :draft, -> { where(is_published: false, is_deleted: false) }
  scope :deleted, -> { where(is_deleted: true) }

  ## -- バリデーション --
  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 2500 }
  # 緯度経度の両方がセットで存在することを確認
  validates :latitude, presence: true, if: :longitude?
  validates :longitude, presence: true, if: :latitude?
  # 公開状態・論理削除ステータスの必須確認
  validates :is_published, inclusion: { in: [true, false] }
  validates :is_deleted, inclusion: { in: [true, false] }
end
