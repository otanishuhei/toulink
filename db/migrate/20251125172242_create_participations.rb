class CreateParticipations < ActiveRecord::Migration[6.1]
  def change
    create_table :participations do |t|
      t.references :user,     null: false, foreign_key: true
      t.references :event,    null: false, foreign_key: true
      t.integer :status,      null: false, default: 0
      t.timestamps
    end
    # 同一ユーザーが同一イベントに重複登録するのを防ぐ
    add_index :participations, [:user_id, :event_id], unique: true
  end
end
