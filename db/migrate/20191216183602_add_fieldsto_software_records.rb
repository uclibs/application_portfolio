# frozen_string_literal: true

# Add remaining fields to software_records table
class AddFieldstoSoftwareRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :software_records, :departments, :string
    add_column :software_records, :date_implemented, :date
    add_column :software_records, :date_of_upgrade, :date
    add_column :software_records, :developers, :string
    add_column :software_records, :tech_leads, :string
    add_column :software_records, :product_owners, :string
    add_column :software_records, :languages_used, :string
    add_column :software_records, :url, :text
    add_column :software_records, :user_seats, :integer
    add_column :software_records, :annual_fees, :string
    add_column :software_records, :support_contract, :string
    add_column :software_records, :hosting_environment, :string
    add_column :software_records, :current_version, :integer
    add_column :software_records, :notes, :string
    add_column :software_records, :business_value, :integer
    add_column :software_records, :it_quality, :integer
  end
end
