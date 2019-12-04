# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SoftwareType, type: :model do
  it 'is valid if all required fields are provided' do
    softwaretype = SoftwareType.new(title: 'Web App', description: 'A web application')
    expect(softwaretype).to be_valid
  end

  it 'is not valid without a single mandatory field (without title)' do
    softwaretype = SoftwareType.new(description: 'A web application')
    expect(softwaretype).to_not be_valid
  end

  it 'is not valid without a single mandatory field (without description)' do
    softwaretype = SoftwareType.new(title: 'Web App')
    expect(softwaretype).to_not be_valid
  end
end
