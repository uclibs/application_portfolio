# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VendorRecord, type: :model do
  it 'is valid if all required fields are provided' do
    vendorrecord = VendorRecord.new(title: 'Open Source', description: 'Just and open source vendor', date_started: '07/11/1996')
    expect(vendorrecord).to be_valid
  end

  it 'is not valid without a single mandatory field (without title)' do
    vendorrecord = VendorRecord.new(description: 'Just and open source vendor', date_started: '07/11/1996')
    expect(vendorrecord).to_not be_valid
  end

  it 'is not valid without a single mandatory field (without description)' do
    vendorrecord = VendorRecord.new(title: 'Open Source', date_started: '07/11/1996')
    expect(vendorrecord).to_not be_valid
  end

  it 'is valid if all required fields are provided (without status)' do
    vendorrecord = VendorRecord.new(title: 'Open Source', description: 'Just and open source vendor')
    expect(vendorrecord).to_not be_valid
  end
end
