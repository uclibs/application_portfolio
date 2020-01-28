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

ActiveRecord::Schema.define(version: 20_200_121_184_332) do
  create_table 'software_records', force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.string 'status'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'software_type_id'
    t.integer 'vendor_record_id'
    t.string 'departments'
    t.date 'date_implemented'
    t.date 'date_of_upgrade'
    t.string 'developers'
    t.string 'tech_leads'
    t.string 'product_owners'
    t.string 'languages_used'
    t.text 'url'
    t.string 'user_seats'
    t.string 'annual_fees'
    t.string 'support_contract'
    t.string 'hosting_environment'
    t.string 'current_version'
    t.string 'notes'
    t.integer 'business_value'
    t.integer 'it_quality'
    t.date 'tentative_date_implemented'
    t.string 'created_by'
    t.text 'sensitive_information'
    t.index ['software_type_id'], name: 'index_software_records_on_software_type_id'
    t.index ['vendor_record_id'], name: 'index_software_records_on_vendor_record_id'
  end

  create_table 'software_types', force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'roles', default: 'viewer'
    t.string 'first_name'
    t.string 'last_name'
    t.string 'department'
    t.string 'title'
    t.boolean 'active', default: true
    t.index ['active'], name: 'index_users_on_active'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  create_table 'vendor_records', force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
