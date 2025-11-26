class Participation < ApplicationRecord
  ## -- アソシエーション --
  belongs_to :user
  belongs_to :event

  ## -- enum --
  # 参加状況
  enum status: {
    pending: 0,
    confirmed: 1,
    rejected: 2
  }

  ## -- バリデーション --
  # 重複登録を防ぐバリデーション
  validates :user_id, uniqueness: { scope: :event_id, message: "は既にこのイベントに参加/申請済みです" }
end
