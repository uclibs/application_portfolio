# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Status, type: :model do
  it 'is valid if all required fields are provided' do
    status = Status.new(title: 'Test', status_type: 'Design')
    expect(status).to be_valid
  end

  it 'is not valid without a single mandatory field (without title)' do
    status = Status.new(status_type: 'Design')
    expect(status).to_not be_valid
  end

  it 'is valid without a single field (without status_type)' do
    status = Status.new(title: 'Design')
    expect(status).to be_valid
  end
end
