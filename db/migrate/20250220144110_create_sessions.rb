class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.string :title, null: false
      t.datetime :started_at, null: false
      t.string :duration, null: false, default: '00:00:00'

      t.timestamps
    end
    add_index :sessions, :title, unique: true
  end
end
