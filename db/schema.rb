# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_01_141552) do
  create_table "game_sessions", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "started_at", null: false
    t.string "duration", default: "00:00:00", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_game_sessions_on_title", unique: true
  end

  create_table "game_sessions_players", id: false, force: :cascade do |t|
    t.integer "game_session_id", null: false
    t.integer "player_id", null: false
    t.index ["game_session_id", "player_id"], name: "index_game_sessions_players_on_game_session_id_and_player_id"
    t.index ["player_id", "game_session_id"], name: "index_game_sessions_players_on_player_id_and_game_session_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.integer "balance", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_players_on_name", unique: true
  end

  create_table "quests", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "status", default: "in_progress"
    t.integer "reward"
    t.integer "game_session_id", null: false
    t.integer "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_session_id"], name: "index_quests_on_game_session_id"
    t.index ["player_id"], name: "index_quests_on_player_id"
  end

  add_foreign_key "quests", "game_sessions"
  add_foreign_key "quests", "players"
end
