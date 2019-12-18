# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SoftwareRecord, type: :model do
  before(:each) do
    VendorRecord.create!(
      title: 'Vendor 1',
      description: 'test vendor'
    )
    SoftwareType.create!(
      title: 'Web app',
      description: 'test software type'
    )
  end
  it 'is valid if all required fields are provided' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC', description: 'UC Digital conservatory preservation library', status: 'In Progress', software_type_id: SoftwareType.first.id, vendor_record_id: VendorRecord.first.id)
    expect(softwarerecord).to be_valid
  end

  it 'is not valid without a single mandatory field (without title)' do
    softwarerecord = SoftwareRecord.new(description: 'UC Digital conservatory preservation library', status: 'In Progress', software_type_id: SoftwareType.first.id, vendor_record_id: VendorRecord.first.id)
    expect(softwarerecord).to_not be_valid
  end

  it 'is not valid without a single mandatory field (without description)' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC', status: 'In Progress', software_type_id: SoftwareType.first.id, vendor_record_id: VendorRecord.first.id)
    expect(softwarerecord).to_not be_valid
  end

  it 'is valid if all required fields are provided (without status)' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC', description: 'UC Digital conservatory preservation library', software_type_id: SoftwareType.first.id, vendor_record_id: VendorRecord.first.id)
    expect(softwarerecord).to_not be_valid
  end

  it 'is valid if all required fields are provided (without software_type_id)' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC', status: 'In Progress', description: 'UC Digital conservatory preservation library', vendor_record_id: VendorRecord.first.id)
    expect(softwarerecord).to_not be_valid
  end

  it 'is valid if all required fields are provided (without vendor_record_id)' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC', status: 'In Progress', description: 'UC Digital conservatory preservation library', vendor_record_id: VendorRecord.first.id)
    expect(softwarerecord).to_not be_valid
  end
end
