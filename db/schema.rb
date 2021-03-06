# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_521_155_541) do
  create_table "file_uploads", force: :cascade do |t|
    t.string "attachment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hosting_environments", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "software_records", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "software_type_id"
    t.integer "vendor_record_id"
    t.string "departments"
    t.date "date_implemented"
    t.date "date_of_upgrade"
    t.string "developers"
    t.string "tech_leads"
    t.string "product_owners"
    t.string "languages_used"
    t.text "production_url"
    t.string "user_seats"
    t.string "annual_fees"
    t.string "support_contract"
    t.string "current_version"
    t.string "notes"
    t.integer "business_value"
    t.integer "it_quality"
    t.string "created_by"
    t.text "sensitive_information"
    t.text "source_code_url"
    t.integer "status_id"
    t.integer "hosting_environment_id"
    t.string "requires_cm"
    t.date "last_security_scan"
    t.date "last_accessibility_scan"
    t.date "last_ogc_review"
    t.date "last_info_sec_review"
    t.text "cm_stakeholders"
    t.text "cm_other_notes"
    t.text "qa_url"
    t.text "dev_url"
    t.text "prod_url"
    t.text "production_support_servers"
    t.date "last_record_change"
    t.string "track_uptime"
    t.string "monitor_health"
    t.string "monitor_errors"
    t.string "authentication_type"
    t.index ["hosting_environment_id"], name: "index_software_records_on_hosting_environment_id"
    t.index ["software_type_id"], name: "index_software_records_on_software_type_id"
    t.index ["status_id"], name: "index_software_records_on_status_id"
    t.index ["vendor_record_id"], name: "index_software_records_on_vendor_record_id"
  end

  create_table "software_types", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string "title"
    t.string "status_type", default: "Other"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "roles", default: "viewer"
    t.string "first_name"
    t.string "last_name"
    t.string "department"
    t.string "title"
    t.boolean "active", default: true
    t.index ["active"], name: "index_users_on_active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vendor_records", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
