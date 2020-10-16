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
    Status.create!(
      title: 'Test',
      status_type: 'Design'
    )
    HostingEnvironment.create!(
      title: 'Test Env.',
      description: 'test env.'
    )
  end
  it 'is valid if all required fields are provided' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC', description: 'UC Digital conservatory preservation library', status_id: Status.first.id, hosting_environment_id: HostingEnvironment.first.id, software_type_id: SoftwareType.first.id, vendor_record_id: VendorRecord.first.id, created_by: 'Test User')
    expect(softwarerecord).to be_valid
  end

  it 'is valid if all required fields are provided' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC 2', description: 'UC Digital conservatory preservation library', status_id: Status.first.id, hosting_environment_id: HostingEnvironment.first.id, software_type_id: SoftwareType.first.id, vendor_record_id: VendorRecord.first.id, created_by: 'Test User2')
    expect(softwarerecord).to be_valid
  end

  it 'is not valid without a single mandatory field (without title)' do
    softwarerecord = SoftwareRecord.new(description: 'UC Digital conservatory preservation library', status_id: Status.first.id, hosting_environment_id: HostingEnvironment.first.id, software_type_id: SoftwareType.first.id, vendor_record_id: VendorRecord.first.id)
    expect(softwarerecord).to_not be_valid
  end

  it 'is not valid without a single mandatory field (without description)' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC', status_id: Status.first.id, hosting_environment_id: HostingEnvironment.first.id, software_type_id: SoftwareType.first.id, vendor_record_id: VendorRecord.first.id)
    expect(softwarerecord).to_not be_valid
  end

  it 'is valid if all required fields are provided (without status)' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC', description: 'UC Digital conservatory preservation library', software_type_id: SoftwareType.first.id, vendor_record_id: VendorRecord.first.id)
    expect(softwarerecord).to_not be_valid
  end

  it 'is valid if all required fields are provided (without software_type_id)' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC', status_id: Status.first.id, hosting_environment_id: HostingEnvironment.first.id, description: 'UC Digital conservatory preservation library', vendor_record_id: VendorRecord.first.id)
    expect(softwarerecord).to_not be_valid
  end

  it 'is valid if all required fields are provided (without vendor_record_id)' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC', status_id: Status.first.id, hosting_environment_id: HostingEnvironment.first.id, description: 'UC Digital conservatory preservation library', vendor_record_id: VendorRecord.first.id)
    expect(softwarerecord).to_not be_valid
  end

  it 'is not valid without a single mandatory field (without created_by)' do
    softwarerecord = SoftwareRecord.new(description: 'UC Digital conservatory preservation library', status_id: Status.first.id, hosting_environment_id: HostingEnvironment.first.id, software_type_id: SoftwareType.first.id, vendor_record_id: VendorRecord.first.id)
    expect(softwarerecord).to_not be_valid
  end
end
