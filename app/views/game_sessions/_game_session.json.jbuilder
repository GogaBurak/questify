json.extract! game_session, :id, :title, :started_at, :duration, :created_at, :updated_at
json.url game_session_url(game_session, format: :json)
