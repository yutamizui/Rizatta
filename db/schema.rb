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

ActiveRecord::Schema.define(version: 2022_08_29_052350) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "makable_reservation_hour_span", default: 24, null: false
    t.integer "cancelable_reservation_hour_span", default: 24, null: false
    t.datetime "calendar_start_time", default: "2000-01-01 10:00:00"
    t.datetime "calendar_end_time", default: "2000-01-01 20:00:00"
    t.index ["company_id"], name: "index_branches_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.string "address", null: false
    t.string "phone", null: false
    t.string "secret_code", null: false
    t.index ["email"], name: "index_companies_on_email", unique: true
    t.index ["reset_password_token"], name: "index_companies_on_reset_password_token", unique: true
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "timeframe_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["timeframe_id"], name: "index_reservations_on_timeframe_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.bigint "branch_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["branch_id"], name: "index_rooms_on_branch_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.string "phone", null: false
    t.integer "status", null: false
    t.bigint "company_id"
    t.bigint "branch_id"
    t.index ["branch_id"], name: "index_staffs_on_branch_id"
    t.index ["company_id"], name: "index_staffs_on_company_id"
    t.index ["email"], name: "index_staffs_on_email", unique: true
    t.index ["reset_password_token"], name: "index_staffs_on_reset_password_token", unique: true
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "user_id"
    t.integer "reservation_id"
    t.datetime "expired_at", default: -> { "CURRENT_TIMESTAMP" }
    t.boolean "status", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "timeframes", force: :cascade do |t|
    t.string "name"
    t.datetime "target_date", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "start_time", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "end_time", default: -> { "CURRENT_TIMESTAMP" }
    t.integer "capacity", default: 1, null: false
    t.integer "color", null: false
    t.integer "staff_id"
    t.bigint "branch_id"
    t.bigint "room_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "required_ticket_number", default: 1, null: false
    t.index ["branch_id"], name: "index_timeframes_on_branch_id"
    t.index ["room_id"], name: "index_timeframes_on_room_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.string "phone", null: false
    t.bigint "company_id"
    t.bigint "branch_id"
    t.index ["branch_id"], name: "index_users_on_branch_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "branches", "companies"
  add_foreign_key "reservations", "timeframes"
  add_foreign_key "reservations", "users"
  add_foreign_key "rooms", "branches"
  add_foreign_key "staffs", "branches"
  add_foreign_key "staffs", "companies"
  add_foreign_key "timeframes", "branches"
  add_foreign_key "timeframes", "rooms"
  add_foreign_key "users", "branches"
  add_foreign_key "users", "companies"
end
