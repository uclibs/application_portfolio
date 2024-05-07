# frozen_string_literal: true

FactoryBot.define do
  factory :software_record do
    association :software_type
    association :vendor_record
    association :status
    association :hosting_environment
    title { 'MyString' }
    description { 'MyText' }
    status_id { Status.first.id }
    date_implemented { '2020-12-12' }
    vendor_record_id { VendorRecord.first.id }
    software_type_id { SoftwareType.first.id }
    hosting_environment_id { HostingEnvironment.first.id }
    created_by { 'Test User' }
    authentication_type { 'Sample Authentication Type' }
    date_of_upgrade { Date.today }
    languages_used { 'Ruby, Python' }
    production_url { 'http://example.com' }
    source_code_url { 'http://github.com' }
    user_seats { 10 }
    annual_fees { 1000.0 }
    support_contract { 'Standard Support' }
    current_version { '1.0.0' }
    notes { 'Sample notes' }
    business_value { 'High' }
    it_quality { 'Good' }
    requires_cm { true }
    last_security_scan { Date.today }
    last_accessibility_scan { Date.today }
    last_ogc_review { Date.today }
    last_info_sec_review { Date.today }
    cm_stakeholders { 'Stakeholder 1' }
    cm_other_notes { 'No additional notes' }
    qa_url { 'http://qa.example.com' }
    dev_url { 'http://dev.example.com' }
    prod_url { 'http://prod.example.com' }
    production_support_servers { 'Server 1, Server 2' }
    last_record_change { Date.today }
    track_uptime { true }
    monitor_health { true }
    monitor_errors { true }
  end
end
