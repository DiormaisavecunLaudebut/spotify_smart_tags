# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_14_100059) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_updates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_data_updates_on_user_id"
  end

  create_table "filter_requests", force: :cascade do |t|
    t.boolean "launched", default: false
    t.string "tags", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_filter_requests_on_user_id"
  end

  create_table "playlist_tracks", force: :cascade do |t|
    t.bigint "playlist_id", null: false
    t.bigint "track_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["playlist_id"], name: "index_playlist_tracks_on_playlist_id"
    t.index ["track_id"], name: "index_playlist_tracks_on_track_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "name"
    t.string "cover_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.string "description"
    t.string "href"
    t.string "external_url"
    t.string "spotify_id"
    t.integer "track_count"
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "spotify_api_calls", force: :cascade do |t|
    t.string "path"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_spotify_api_calls_on_user_id"
  end

  create_table "spotify_tokens", force: :cascade do |t|
    t.string "code"
    t.string "refresh_token"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "expires_at", null: false
    t.index ["user_id"], name: "index_spotify_tokens_on_user_id"
  end

  create_table "sptags", force: :cascade do |t|
    t.string "name"
    t.integer "track_count", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_sptags_on_user_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "trackland_playlists", force: :cascade do |t|
    t.string "name"
    t.string "tags", array: true
    t.boolean "name_set"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "cover_url"
    t.bigint "playlist_id"
    t.index ["playlist_id"], name: "index_trackland_playlists_on_playlist_id"
    t.index ["user_id"], name: "index_trackland_playlists_on_user_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name"
    t.string "artist"
    t.string "cover_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_tag", default: false
    t.bigint "user_id", null: false
    t.string "href"
    t.integer "duration"
    t.string "external_url"
    t.string "spotify_id"
    t.string "spotify_tags", default: [], array: true
    t.index ["user_id"], name: "index_tracks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "uid"
    t.string "spotify_client"
    t.string "email"
    t.string "country"
    t.string "external_url"
    t.string "display_name"
    t.string "product"
    t.integer "followers"
    t.string "username", null: false
    t.boolean "admin", default: false, null: false
    t.string "locale", default: "fr", null: false
    t.integer "points", default: 0, null: false
    t.string "status", default: "amateur", null: false
    t.string "connectors", default: [], array: true
    t.string "request_tags", default: [], array: true
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid"
  end

  add_foreign_key "data_updates", "users"
  add_foreign_key "filter_requests", "users"
  add_foreign_key "playlist_tracks", "playlists"
  add_foreign_key "playlist_tracks", "tracks"
  add_foreign_key "playlists", "users"
  add_foreign_key "spotify_api_calls", "users"
  add_foreign_key "spotify_tokens", "users"
  add_foreign_key "sptags", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "trackland_playlists", "users"
  add_foreign_key "tracks", "users"
end
