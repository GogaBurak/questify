json.extract! session, :id, :title, :started_at, :duration, :created_at, :updated_at
json.url session_url(session, format: :json)
