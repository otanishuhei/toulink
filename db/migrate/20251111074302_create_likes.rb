class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.references :post, null: false, foreign_key: true, type: :bigint
      t.timestamps
    end
    # 同じユーザーによる2回以上のいいねの禁止
    add_index :likes, [:user_id, :post_id], unique: true
  end
end
