class CreateFollows < ActiveRecord::Migration[6.1]
  def change
    create_table :follows do |t|
      t.bigint :follower_id, null: false
      t.bigint :followed_id, null: false
      t.timestamps
    end

    # 外部キー制約
    add_foreign_key :follows, :users, column: :follower_id
    add_foreign_key :follows, :users, column: :followed_id
    # 同じユーザーによる重複フォロー禁止
    add_index :follows, [:follower_id, :followed_id], unique: true
    # フォロー,フォロワーの検索高速化
    add_index :follows, :follower_id
    add_index :follows, :followed_id
  end
end
