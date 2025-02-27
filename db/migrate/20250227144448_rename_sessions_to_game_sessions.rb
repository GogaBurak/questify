class RenameSessionsToGameSessions < ActiveRecord::Migration[8.0]
  def change
    remove_index :sessions, :title, unique: true
    rename_table :sessions, :game_sessions
    add_index :game_sessions, :title, unique: true
  end
end
