class Like < ApplicationRecord
  ## -- アソシエーション --
  # いいねしたユーザー
  belongs_to :user
  # いいね対象の投稿
  belongs_to :post

  ## -- バリデーション --
  # 同じユーザーが同じ投稿に複数いいねすることを防ぐ（マイグレーションと連携）
  validates :user_id, uniqueness: { scope: :post_id, message: "は同じ投稿に複数回いいねできません" }
end
