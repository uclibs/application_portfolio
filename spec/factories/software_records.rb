# frozen_string_literal: true

FactoryBot.define do
  factory :software_record do
    title { 'MyString' }
    description { 'MyText' }
    status_id { Status.first.id }
    date_implemented { '2020-12-12' }
    vendor_record_id { VendorRecord.second.id }
    software_type_id { SoftwareType.second.id }
    created_by { 'Test User' }
  end
end
