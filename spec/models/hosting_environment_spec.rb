# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HostingEnvironment, type: :model do
  it 'is valid if all required fields are provided' do
    hosting_environment = HostingEnvironment.new(title: 'Test', description: 'test')
    expect(hosting_environment).to be_valid
  end

  it 'is not valid without a single mandatory field (without title)' do
    hosting_environment = HostingEnvironment.new(description: 'test')
    expect(hosting_environment).to_not be_valid
  end

  it 'is valid without a single field (without description)' do
    hosting_environment = HostingEnvironment.new(title: 'Test')
    expect(hosting_environment).to be_valid
  end
end
