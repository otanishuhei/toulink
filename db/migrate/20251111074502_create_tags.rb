class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :name,         null: false
      t.boolean :is_deleted,  null: false, default: false
      t.timestamps
    end
    # タグ名の重複禁止
    add_index :tags, :name, unique: true
  end
end
