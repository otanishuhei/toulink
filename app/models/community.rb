class Community < ApplicationRecord
  ## -- アソシエーション --
  # オーナー (User)
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  # メンバー
  has_many :community_members, dependent: :destroy
  has_many :members, through: :community_members, source: :user
  # has_many :events, dependent: :destroy（今後 Event モデルを作成予定）
  # Active Storage (コミュニティ画像)
  has_one_attached :community_image

  ## -- スコープ --
  # コミュニティステータスの検索
  scope :active, -> { where(is_active: true) }

  ## -- バリデーション --
  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 50 }
  validates :description, length: { maximum: 300 }, allow_blank: true
  validates :is_active, inclusion: { in: [true, false] }

  ## -- コールバック --
  # コミュニティ作成時にオーナーを leader として CommunityMember に登録
  after_create :add_owner_as_member

  private

    def add_owner_as_member
      CommunityMember.create(user_id: owner_id, community: self, role: :leader)
    end
end
