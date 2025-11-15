class CommunityMember < ApplicationRecord
  ## -- アソシエーション --
  # ユーザーとコミュニティの中間テーブル
  belongs_to :user
  belongs_to :community

  ## -- enum --
  # 役割の定義
  enum role: { member: 0, leader: 1 }

  ## -- バリデーション --
  # 役割の確認
  validates :role, inclusion: { in: roles.keys }
  # 重複参加の防止（マイグレーションと連携）
  validates :user_id, uniqueness: { scope: :community_id, message: "は既に参加しています" }
end
