class CreateCommunityMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :community_members do |t|
      t.references  :user,        null: false, foreign_key: true
      t.references  :community,   null: false, foreign_key: true
      t.integer     :role,        null: false, default: 0
      t.timestamps
    end
  end
end
