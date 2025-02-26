class CreateJoinTableSessionsUsers < ActiveRecord::Migration[8.0]
  def change
    create_join_table :sessions, :players do |t|
      t.index [ :session_id, :player_id ]
      t.index [ :player_id, :session_id ]
    end
  end
end
