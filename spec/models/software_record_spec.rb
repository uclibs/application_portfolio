# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SoftwareRecord, type: :model do
  it 'is valid if all required fields are provided' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC', description: 'UC Digital conservatory preservation library', status: 'In Progress')
    expect(softwarerecord).to be_valid
  end

  it 'is not valid without a single mandatory field (without title)' do
    softwarerecord = SoftwareRecord.new(description: 'UC Digital conservatory preservation library', status: 'In Progress')
    expect(softwarerecord).to_not be_valid
  end

  it 'is not valid without a single mandatory field (without description)' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC', status: 'In Progress')
    expect(softwarerecord).to_not be_valid
  end

  it 'is valid if all required fields are provided (without status)' do
    softwarerecord = SoftwareRecord.new(title: 'Scholar UC', description: 'UC Digital conservatory preservation library')
    expect(softwarerecord).to_not be_valid
  end
end
