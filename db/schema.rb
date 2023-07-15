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

ActiveRecord::Schema[7.0].define(version: 2023_07_15_204412) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
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

  create_table "app_settings", force: :cascade do |t|
    t.string "app_name"
    t.integer "disable_booking_threshold"
    t.datetime "am_pm_hour_separation"
    t.datetime "minimal_replacement_length"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cdoms", force: :cascade do |t|
    t.string "departement"
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doctors", force: :cascade do |t|
    t.string "title"
    t.string "last_name"
    t.string "first_name"
    t.string "rpps"
    t.string "speciality"
    t.string "conventional_sector"
    t.boolean "optam"
    t.string "phone"
    t.string "email"
    t.integer "signature_blob_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["signature_blob_id"], name: "index_doctors_on_signature_blob_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "site_id", null: false
    t.integer "doctor_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "number_of_patients"
    t.boolean "helper"
    t.integer "user_id"
    t.decimal "amount"
    t.decimal "reversion", default: "70.0"
    t.decimal "amount_paid"
    t.boolean "contract_generated"
    t.boolean "contract_validated"
    t.boolean "editable"
    t.integer "patient_count"
    t.datetime "am_min_hour"
    t.datetime "am_max_hour"
    t.datetime "pm_min_hour"
    t.datetime "pm_max_hour"
    t.string "contract_blob_type"
    t.integer "contract_blob_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_blob_type", "contract_blob_id"], name: "index_events_on_contract_blob"
    t.index ["doctor_id"], name: "index_events_on_doctor_id"
    t.index ["site_id"], name: "index_events_on_site_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "mailing_lists", force: :cascade do |t|
    t.string "name"
    t.text "text"
    t.integer "site_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_mailing_lists_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "postal_code"
    t.string "city"
    t.string "software"
    t.text "informations"
    t.integer "cdom_id"
    t.string "color"
    t.integer "min_patients"
    t.integer "max_patients"
    t.integer "min_patients_helped"
    t.integer "max_patients_helped"
    t.datetime "am_min_hour"
    t.datetime "am_max_hour"
    t.datetime "pm_min_hour"
    t.datetime "pm_max_hour"
    t.datetime "min_lenght"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cdom_id"], name: "index_sites_on_cdom_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.boolean "role", default: false
    t.string "last_name"
    t.string "first_name"
    t.date "date_of_birth"
    t.string "phone"
    t.string "address"
    t.string "postal_code"
    t.string "city"
    t.string "siret_number"
    t.string "license_number"
    t.string "rib"
    t.string "speciality"
    t.integer "mailing_list_id"
    t.boolean "active"
    t.string "uid"
    t.string "provider"
    t.integer "signature_blob_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["mailing_list_id"], name: "index_users_on_mailing_list_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["signature_blob_id"], name: "index_users_on_signature_blob_id", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "doctors", "active_storage_blobs", column: "signature_blob_id"
  add_foreign_key "events", "doctors"
  add_foreign_key "events", "sites"
  add_foreign_key "events", "users"
  add_foreign_key "mailing_lists", "sites"
  add_foreign_key "sites", "cdoms"
  add_foreign_key "users", "active_storage_blobs", column: "signature_blob_id"
  add_foreign_key "users", "mailing_lists"
end
