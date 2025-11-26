class Comment < ApplicationRecord
  ## -- アソシエーション --
  # コメント投稿者
  belongs_to :user
  # コメント対象の投稿
  belongs_to :post

  ## -- スコープ --
  # コメントステータス別検索
  scope :published, -> { where(is_published: true, is_deleted: false) }
  scope :deleted, -> { where(is_deleted: true) }

  ## -- バリデーション --
  validates :body, presence: true, length: { maximum: 200 }
  # 公開状態・論理削除ステータスの必須確認
  validates :is_published, inclusion: { in: [true, false] }
  validates :is_deleted, inclusion: { in: [true, false] }
end
