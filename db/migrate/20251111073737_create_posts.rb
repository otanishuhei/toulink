class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references  :user,          null: false, foreign_key: true, type: :bigint
      t.string      :title,         null: false
      t.text        :body,          null: false
      t.float       :latitude
      t.float       :longitude
      t.boolean     :is_published,  null: false, default: true
      t.boolean     :is_deleted,    null: false, default: false
      t.timestamps
    end
  end
end
