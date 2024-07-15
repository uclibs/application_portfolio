# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'MultiValueFields', type: :feature, js: true do
  let(:user) { FactoryBot.create(:admin) }
  let(:software_record) { FactoryBot.create(:software_record) }

  before do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'random1234'
    click_button 'Login'
    visit edit_software_record_path(software_record)
  end

  scenario 'User can add and remove multiple developers' do
    within('#multiple_developers') do
      expect(page).to have_selector('.input-group', count: 1)
      find('a', text: '+ add more').click
      expect(page).to have_selector('.input-group', count: 2)
      all('.input-group-append').last.click
      expect(page).to have_selector('.input-group', count: 1)
    end
  end

  scenario 'User can add and remove multiple tech leads' do
    within('#multiple_tech_leads') do
      expect(page).to have_selector('.input-group', count: 1)
      find('a', text: '+ add more').click
      expect(page).to have_selector('.input-group', count: 2)
      all('.input-group-append').last.click
      expect(page).to have_selector('.input-group', count: 1)
    end
  end

  scenario 'User can add and remove multiple departments' do
    within('#multiple_departments') do
      expect(page).to have_selector('.input-group', count: 1)
      find('a', text: '+ add more').click
      expect(page).to have_selector('.input-group', count: 2)
      all('.input-group-append').last.click
      expect(page).to have_selector('.input-group', count: 1)
    end
  end

  scenario 'User can add and remove multiple product owners' do
    within('#multiple_product_owners') do
      expect(page).to have_selector('.input-group', count: 1)
      find('a', text: '+ add more').click

      expect(page).to have_selector('.input-group', count: 2)

      all('.input-group-append').last.click
      expect(page).to have_selector('.input-group', count: 1)
    end
  end

  scenario 'User can add and remove multiple admin users' do
    within('#multiple_admin_users') do
      expect(page).to have_selector('.input-group', count: 1)
      find('a', text: '+ add more').click

      expect(page).to have_selector('.input-group', count: 2)

      all('.input-group-append').last.click
      expect(page).to have_selector('.input-group', count: 1)
    end
  end
end
