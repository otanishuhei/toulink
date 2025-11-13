class CreateCommunities < ActiveRecord::Migration[6.1]
  def change
    create_table :communities do |t|
      t.references  :owner, null: false, foreign_key: { to_table: :users } # owner_idをusersと関連付け
      t.string      :name,        null: false
      t.text        :description
      t.boolean     :is_active,   null: false, default: true
      t.timestamps
    end
    # コミュニティ名の重複禁止
    add_index :communities, :name, unique: true
  end
end
