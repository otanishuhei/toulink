class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user,       null: false, foreign_key: true, type: :bigint
      t.references :post,       null: false, foreign_key: true, type: :bigint
      t.text :body,             null: false
      t.boolean :is_published,  null: false, default: true
      t.boolean :is_deleted,    null: false, default: false
      t.timestamps
    end
  end
end
