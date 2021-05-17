# frozen_string_literal: true

class AddServerfieldsToSoftwareRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :software_records, :qa_url, :text
    add_column :software_records, :dev_url, :text
    add_column :software_records, :prod_url, :text
    add_column :software_records, :production_support_servers, :text
    add_column :software_records, :last_record_change, :date
    add_column :software_records, :track_uptime, :string
    add_column :software_records, :monitor_health, :string
    add_column :software_records, :monitor_errors, :string
  end
end
