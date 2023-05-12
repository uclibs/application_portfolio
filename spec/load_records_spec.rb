# frozen_string_literal: true

require 'rails_helper'
require "#{Dir.pwd}/load_records.rb"

RSpec.describe LoadRecords do
  describe 'software_records' do
    it 'can load general metadata' do
      LoadRecords.table_name = 'software_records'
      expect(LoadRecords.new).to respond_to(:title,
                                            :description,
                                            :status_id,
                                            :software_type_id,
                                            :vendor_record_id,
                                            :departments,
                                            :date_implemented,
                                            :developers,
                                            :tech_leads,
                                            :product_owners,
                                            :admin_users,
                                            :languages_used,
                                            :production_url,
                                            :source_code_url,
                                            :user_seats,
                                            :annual_fees,
                                            :support_contract,
                                            :hosting_environment_id,
                                            :current_version,
                                            :notes,
                                            :business_value,
                                            :it_quality,
                                            :created_by,
                                            :sensitive_information,
                                            :authentication_type)
    end

    it 'can load change management metadata' do
      LoadRecords.table_name = 'software_records'
      expect(LoadRecords.new).to respond_to(:requires_cm,
                                            :last_security_scan,
                                            :last_accessibility_scan,
                                            :last_ogc_review,
                                            :last_info_sec_review,
                                            :cm_stakeholders,
                                            :cm_other_notes)
    end

    it 'can load server env metadata' do
      LoadRecords.table_name = 'software_records'
      expect(LoadRecords.new).to respond_to(:date_of_upgrade,
                                            :qa_url,
                                            :dev_url,
                                            :prod_url,
                                            :production_support_servers,
                                            :last_record_change,
                                            :track_uptime,
                                            :monitor_health,
                                            :monitor_errors)
    end
  end
end
