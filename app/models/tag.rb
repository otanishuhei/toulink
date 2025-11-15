class Tag < ApplicationRecord
  ## -- アソシエーション --
  # 投稿との関連（中間テーブル経由）
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  ## -- スコープ --
  # 削除されていないタグの検索
  scope :active, -> { where(is_deleted: false) }

  ## -- バリデーション --
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :is_deleted, inclusion: { in: [true, false] }
end
