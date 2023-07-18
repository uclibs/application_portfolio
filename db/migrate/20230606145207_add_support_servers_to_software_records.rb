# frozen_string_literal: true

class AddSupportServersToSoftwareRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :software_records, :qa_support_servers, :text
    add_column :software_records, :dev_support_servers, :text
    add_column :software_records, :date_cert_expires, :date
    add_column :software_records, :monitor_certificates, :string
  end
end
