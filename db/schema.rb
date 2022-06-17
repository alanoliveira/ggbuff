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

ActiveRecord::Schema.define(version: 2022_06_14_152908) do

  create_table "matches", force: :cascade do |t|
    t.integer "store_id", null: false
    t.integer "player_id", null: false
    t.integer "opponent_id"
    t.integer "player_char", null: false
    t.integer "opponent_char", null: false
    t.integer "player_rank"
    t.integer "opponent_rank"
    t.integer "result", null: false
    t.integer "rank_change"
    t.datetime "played_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "matches_load_process_id", null: false
    t.index ["matches_load_process_id"], name: "index_matches_on_matches_load_process_id"
    t.index ["opponent_char"], name: "index_matches_on_opponent_char"
    t.index ["opponent_id"], name: "index_matches_on_opponent_id"
    t.index ["opponent_rank"], name: "index_matches_on_opponent_rank"
    t.index ["player_char"], name: "index_matches_on_player_char"
    t.index ["player_id"], name: "index_matches_on_player_id"
    t.index ["player_rank"], name: "index_matches_on_player_rank"
    t.index ["result"], name: "index_matches_on_result"
    t.index ["store_id"], name: "index_matches_on_store_id"
  end

  create_table "matches_load_processes", force: :cascade do |t|
    t.integer "state", default: 0
    t.integer "player_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_matches_load_processes_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "player_name"
    t.integer "ggxrd_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ggxrd_user_id"], name: "index_players_on_ggxrd_user_id", unique: true
    t.index ["player_name"], name: "index_players_on_player_name"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_stores_on_name"
  end

  add_foreign_key "matches", "matches_load_processes"
  add_foreign_key "matches", "players"
  add_foreign_key "matches", "players", column: "opponent_id"
  add_foreign_key "matches", "stores"
  add_foreign_key "matches_load_processes", "players"
end
