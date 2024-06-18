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

ActiveRecord::Schema[7.1].define(version: 2024_06_18_170105) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "asso_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assos", force: :cascade do |t|
    t.string "name"
    t.string "code_nra"
    t.string "code_siret"
    t.string "code_siren"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.bigint "asso_type_id", null: false
    t.index ["asso_type_id"], name: "index_assos_on_asso_type_id"
    t.index ["user_id"], name: "index_assos_on_user_id"
  end

  create_table "donations", force: :cascade do |t|
    t.bigint "donator_id", null: false
    t.bigint "place_id", null: false
    t.integer "amount"
    t.datetime "occured_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donator_id"], name: "index_donations_on_donator_id"
    t.index ["place_id"], name: "index_donations_on_place_id"
  end

  create_table "donators", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_donators_on_user_id"
  end

  create_table "place_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "street_no"
    t.string "city"
    t.string "country"
    t.bigint "asso_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "place_types_id", null: false
    t.index ["asso_id"], name: "index_places_on_asso_id"
    t.index ["place_types_id"], name: "index_places_on_place_types_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "assos", "asso_types"
  add_foreign_key "assos", "users"
  add_foreign_key "donations", "donators"
  add_foreign_key "donations", "places"
  add_foreign_key "donators", "users"
  add_foreign_key "places", "assos"
  add_foreign_key "places", "place_types", column: "place_types_id"
end
