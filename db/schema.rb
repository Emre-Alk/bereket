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

ActiveRecord::Schema[7.1].define(version: 2025_03_17_160331) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "account_status", ["disabled", "active"]
  create_enum "donator_status", ["visitor", "enrolled"]
  create_enum "requirement_status", ["past", "currently", "eventually", "clear"]
  create_enum "status", ["pending", "processing", "processed", "failed"]
  create_enum "user_status", ["visitor", "active"]

  create_table "accounts", force: :cascade do |t|
    t.string "stripe_id"
    t.boolean "payouts_enabled"
    t.boolean "charges_enabled"
    t.bigint "asso_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_bank_account_id"
    t.string "last_four"
    t.enum "requirements", default: "clear", null: false, enum_type: "requirement_status"
    t.datetime "stripe_deadline"
    t.enum "status", default: "active", null: false, enum_type: "account_status"
    t.index ["asso_id"], name: "index_accounts_on_asso_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.text "objet", null: false
    t.index ["asso_type_id"], name: "index_assos_on_asso_type_id"
    t.index ["user_id"], name: "index_assos_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "stripe_id"
    t.bigint "donator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donator_id"], name: "index_customers_on_donator_id"
  end

  create_table "donations", force: :cascade do |t|
    t.bigint "donator_id"
    t.bigint "place_id", null: false
    t.integer "amount"
    t.datetime "occured_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "checkout_session_id"
    t.integer "amount_net"
    t.string "mode", default: "virement, prélèvement, carte bancaire", null: false
    t.index ["donator_id"], name: "index_donations_on_donator_id"
    t.index ["place_id"], name: "index_donations_on_place_id"
  end

  create_table "donators", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "status", default: "enrolled", null: false, enum_type: "donator_status"
    t.string "address"
    t.string "zip_code"
    t.string "country"
    t.string "city"
    t.boolean "completed", default: false, null: false
    t.index ["user_id"], name: "index_donators_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.json "data"
    t.string "source"
    t.text "processing_errors"
    t.enum "status", default: "pending", null: false, enum_type: "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "donator_id", null: false
    t.bigint "place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donator_id"], name: "index_favorites_on_donator_id"
    t.index ["place_id"], name: "index_favorites_on_place_id"
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
    t.bigint "place_type_id", null: false
    t.string "qr_code"
    t.string "zip_code", null: false
    t.index ["asso_id"], name: "index_places_on_asso_id"
    t.index ["place_type_id"], name: "index_places_on_place_type_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "donation_id", null: false
    t.index ["donation_id"], name: "index_reviews_on_donation_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "volunteerings", force: :cascade do |t|
    t.bigint "volunteer_id", null: false
    t.bigint "host_place_id", null: false
    t.boolean "has_access_to_donation", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["host_place_id"], name: "index_volunteerings_on_host_place_id"
    t.index ["volunteer_id"], name: "index_volunteerings_on_volunteer_id"
  end

  add_foreign_key "accounts", "assos"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assos", "asso_types"
  add_foreign_key "assos", "users"
  add_foreign_key "customers", "donators"
  add_foreign_key "donations", "donators"
  add_foreign_key "donations", "places"
  add_foreign_key "donators", "users"
  add_foreign_key "favorites", "donators"
  add_foreign_key "favorites", "places"
  add_foreign_key "places", "assos"
  add_foreign_key "places", "place_types"
  add_foreign_key "reviews", "donations"
  add_foreign_key "volunteerings", "donators", column: "volunteer_id"
  add_foreign_key "volunteerings", "places", column: "host_place_id"
end
