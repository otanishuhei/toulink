class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.references :community,      null: false, foreign_key: true
      t.references :organizer,      null: false, foreign_key: { to_table: :users }
      t.string :title,              null: false
      t.text :description,          null: false
      t.string :meeting_place,      null: false
      t.string :destination,        null: false
      t.datetime :start_at,         null: false
      t.integer :max_participants
      t.integer :pace_required,     null: false, default: 0
      t.integer :status,            null: false, default: 0
      t.boolean :is_deleted,        null: false, default: false
      t.timestamps
    end
  end
end
