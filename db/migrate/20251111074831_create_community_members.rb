class CreateCommunityMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :community_members do |t|
      t.references  :user,        null: false, foreign_key: true
      t.references  :community,   null: false, foreign_key: true
      t.integer     :role,        null: false, default: 0 # enumで管理（0: メンバー, 1: リーダー）
      t.timestamps
    end
    # 同じユーザーが同じコミュニティに重複して登録されるのを禁止する
    add_index :community_members, [:user_id, :community_id], unique:true
  end
end
