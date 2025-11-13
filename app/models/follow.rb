class Follow < ApplicationRecord
  ## -- アソシエーション --
  # フォローするユーザー（follower）
  belongs_to :follower, class_name: 'User'
  # フォローされるユーザー（followed）
  belongs_to :followed, class_name: 'User'
  
  ## -- バリデーション --
  # 同じユーザーを複数回フォローすることを防ぐ
  validates :follower_id, uniqueness: { scope: :followed_id, message: "は既にフォローしています" }
  # 自分自身をフォローできないようにする
  validate :cannot_follow_self

  private

  def cannot_follow_self
    errors.add(:followed_id, "は自分自身であってはなりません") if follower_id == followed_id
  end
end
