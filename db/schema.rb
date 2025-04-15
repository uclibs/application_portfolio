# frozen_string_literal: true

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

ActiveRecord::Schema[7.2].define(version: 20_250_414_164_358) do
  create_table "change_requests", force: :cascade do |t|
    t.integer "software_record_id", null: false
    t.string "change_title"
    t.text "change_description"
    t.date "change_submitted_date"
    t.boolean "change_completed", default: false
    t.date "change_scheduled_date"
    t.date "change_completed_date"
    t.string "manager_last_name"
    t.string "manager_first_name"
    t.string "manager_work_phone"
    t.string "manager_contact_phone"
    t.string "manager_department"
    t.string "manager_email"
    t.string "director_last_name"
    t.string "director_first_name"
    t.string "director_work_phone"
    t.string "director_contact_phone"
    t.string "director_department"
    t.string "director_email"
    t.integer "application_pages"
    t.integer "number_roles"
    t.boolean "authentication_needed", default: true
    t.boolean "custom_error_pages", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["software_record_id"], name: "index_change_requests_on_software_record_id"
  end

  create_table "file_uploads", force: :cascade do |t|
    t.string "attachment"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "hosting_environments", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "software_records", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.text "notes"
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
    t.text "admin_users"
    t.boolean "themes"
    t.boolean "modules"
    t.string "service"
    t.string "installed_version"
    t.string "proposed_version"
    t.date "last_upgrade_date"
    t.boolean "upgrade_available"
    t.boolean "vulnerabilities_reported"
    t.boolean "vulnerabilities_fixed"
    t.boolean "bug_fixes"
    t.boolean "new_features"
    t.boolean "breaking_changes"
    t.boolean "end_of_life"
    t.integer "priority"
    t.string "upgrade_status"
    t.string "who"
    t.string "semester"
    t.string "upgrade_docs"
    t.text "qa_support_servers"
    t.text "dev_support_servers"
    t.date "date_cert_expires"
    t.string "monitor_certificates"
    t.text "road_map"
    t.text "maintenance_note"
    t.index ["hosting_environment_id"], name: "index_software_records_on_hosting_environment_id"
    t.index ["software_type_id"], name: "index_software_records_on_software_type_id"
    t.index ["status_id"], name: "index_software_records_on_status_id"
    t.index ["vendor_record_id"], name: "index_software_records_on_vendor_record_id"
  end

  create_table "software_types", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string "title"
    t.string "status_type", default: "Other"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "change_requests", "software_records"
  add_foreign_key "software_records", "hosting_environments"
  add_foreign_key "software_records", "software_types"
  add_foreign_key "software_records", "statuses"
  add_foreign_key "software_records", "vendor_records"
end
