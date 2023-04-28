# frozen_string_literal: true

FactoryBot.define do
  factory :software_record do
    title { 'MyString' }
    description { 'MyText' }
    status_id { Status.first.id }
    date_implemented { '2020-12-12' }
    vendor_record_id { VendorRecord.first.id }
    software_type_id { SoftwareType.first.id }
    hosting_environment_id { HostingEnvironment.first.id }
    created_by { 'Test User' }
  end
end
