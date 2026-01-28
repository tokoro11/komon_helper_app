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

ActiveRecord::Schema[7.2].define(version: 2026_01_27_120854) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "gym_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "status"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gym_id"], name: "index_bookings_on_gym_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "gyms", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "match_applications", force: :cascade do |t|
    t.bigint "match_listing_id", null: false
    t.bigint "applicant_id", null: false
    t.integer "status", default: 0, null: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_id", "match_listing_id"], name: "index_match_apps_on_applicant_and_listing", unique: true
    t.index ["applicant_id"], name: "index_match_applications_on_applicant_id"
    t.index ["match_listing_id"], name: "index_match_applications_on_match_listing_id"
  end

  create_table "match_listings", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.bigint "gym_id", null: false
    t.date "match_date", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.integer "gender_category", null: false
    t.integer "school_category", null: false
    t.integer "status", default: 0, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gym_id"], name: "index_match_listings_on_gym_id"
    t.index ["owner_id"], name: "index_match_listings_on_owner_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "gym_id", null: false
    t.datetime "starts_at"
    t.bigint "team_a_id"
    t.bigint "team_b_id"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "match_listing_id"
    t.string "team_a_name"
    t.string "team_b_name"
    t.index ["gym_id"], name: "index_matches_on_gym_id"
    t.index ["match_listing_id"], name: "index_matches_on_match_listing_id", unique: true
    t.index ["team_a_id"], name: "index_matches_on_team_a_id"
    t.index ["team_b_id"], name: "index_matches_on_team_b_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "kind"
    t.string "title"
    t.text "body"
    t.datetime "read_at"
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.bigint "team_id"
    t.string "name"
    t.string "email", default: "", null: false
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "affiliation"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "bookings", "gyms"
  add_foreign_key "bookings", "users"
  add_foreign_key "match_applications", "match_listings"
  add_foreign_key "match_applications", "users", column: "applicant_id"
  add_foreign_key "match_listings", "gyms"
  add_foreign_key "match_listings", "users", column: "owner_id"
  add_foreign_key "matches", "gyms"
  add_foreign_key "matches", "match_listings"
  add_foreign_key "matches", "teams", column: "team_a_id"
  add_foreign_key "matches", "teams", column: "team_b_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "users", "teams"
end
