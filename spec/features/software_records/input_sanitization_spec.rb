# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Input sanitization', type: :feature, js: true do
  let(:user) { FactoryBot.create(:admin) }

  before { login_as(user, scope: :user) }

  scenario 'strips non-alphanumeric characters from created_by on new software record form' do
    visit new_software_record_path

    field = find_by_id('software_record_created_by')
    field.set('John@Doe! 123')

    expect(field.value).to eq('JohnDoe 123')
  end
end
