# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'MultiValueFields', type: :feature, js: true do
  let(:user) { FactoryBot.create(:admin) }
  let(:software_record) { FactoryBot.create(:software_record) }

  before do
    login_as(user, scope: :user)
  end

  # multivalueinputs.js drives every _form_multi_* partial the same way (data-field-name only).
  scenario 'User can add and remove multiple values in a multi-value field' do
    visit edit_software_record_path(software_record)
    expect(page).to have_selector('#software_record_title')

    within('#multiple_developers') do
      expect(page).to have_selector('.input-group', count: 1)
      find('button.js-add-multivalue', text: '+ add more').click
      find('button.js-add-multivalue', text: '+ add more').click

      all('.input-group input').each_with_index do |input, index|
        input.set("Developer #{index + 1}")
      end

      expect(page).to have_selector('.input-group', count: 3)

      all('.input-group')[1].find('button.js-remove-multivalue', text: 'Delete').click
      expect(page).to have_selector('.input-group', count: 2)
      expect(page).not_to have_field(with: 'Developer 2')
      expect(page).to have_field(with: 'Developer 1')
      expect(page).to have_field(with: 'Developer 3')
    end
  end
end
