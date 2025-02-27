class CreateJoinTableGameSessionsUsers < ActiveRecord::Migration[8.0]
  def change
    create_join_table :game_sessions, :players do |t|
      t.index [ :game_session_id, :player_id ]
      t.index [ :player_id, :game_session_id ]
    end
  end
end
