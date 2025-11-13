class PostTag < ApplicationRecord
  ## -- アソシエーション --
  # 投稿とタグの中間テーブル
  belongs_to :post
  belongs_to :tag

  ## -- バリデーション --
  # 同じ投稿に同じタグを複数回つけられないようにする（マイグレーションと連携）
  validates :tag_id, uniqueness: { scope: :post_id, message: "はこの投稿に既に付いています" }
end
