class Event < ApplicationRecord
  ## -- アソシエーション --
  belongs_to :community
  belongs_to :organizer, class_name: "User", foreign_key: "organizer_id"
  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, source: :user

  ## -- enum --
  # 走行ペース
  enum pace_required: {
    pace_any: 0,
    pace_slow: 1,
    pace_average: 2,
    pace_fast: 3
  }

  # 募集/進行ステータス
  enum status: {
    draft: 0,        # 企画中（非公開）
    recruiting: 1,   # 募集中（公開）
    closed: 2,       # 募集終了（公開）
    finished: 3,     # 終了（公開）
    suspended: 4     # 停止中（非公開/非表示）
  }

  def self.organizer_editable_statuses
    # :suspended (4) を除外したキーの配列を返す
    statuses.except(:suspended).keys
  end
end