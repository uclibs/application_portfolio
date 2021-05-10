# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VendorRecord, type: :model do
  it 'is valid if all required fields are provided' do
    vendorrecord = VendorRecord.new(title: 'Open Source',
                                    description: 'Just and open source vendor')
    expect(vendorrecord).to be_valid
  end

  it 'is not valid without a single mandatory field (without title)' do
    vendorrecord = VendorRecord.new(description: 'Just and open source vendor')
    expect(vendorrecord).to_not be_valid
  end

  it 'is valid if all required fields are provided (without description)' do
    vendorrecord = VendorRecord.new(title: 'Open Source')
    expect(vendorrecord).to_not be_valid
  end
end
