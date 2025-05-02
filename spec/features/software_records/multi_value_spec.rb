# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'MultiValueFields', type: :feature, js: true do
  let(:user) { FactoryBot.create(:admin) }
  let(:software_record) { FactoryBot.create(:software_record) }

  before do
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'random1234'
    click_button 'Login'
    visit edit_software_record_path(software_record)
  end

  scenario 'User can add and remove multiple developers' do
    within('#multiple_developers') do
      expect(page).to have_selector('.input-group', count: 1)
      find('button', text: '+ add more').click
      find('button', text: '+ add more').click

      all('.input-group input').each_with_index do |input, index|
        input.set("Developer #{index + 1}")
      end

      expect(page).to have_selector('.input-group', count: 3)

      all('.input-group-append')[1].click
      expect(page).to have_selector('.input-group', count: 2)
      expect(page).not_to have_field(with: 'Developer 2')
      expect(page).to have_field(with: 'Developer 1')
      expect(page).to have_field(with: 'Developer 3')
    end
  end

  scenario 'User can add and remove multiple tech leads' do
    within('#multiple_tech_leads') do
      expect(page).to have_selector('.input-group', count: 1)
      find('button', text: '+ add more').click
      find('button', text: '+ add more').click

      all('.input-group input').each_with_index do |input, index|
        input.set("Tech Lead #{index + 1}")
      end

      expect(page).to have_selector('.input-group', count: 3)

      all('.input-group-append')[1].click
      expect(page).to have_selector('.input-group', count: 2)
      expect(page).not_to have_field(with: 'Tech Lead 2')
      expect(page).to have_field(with: 'Tech Lead 1')
      expect(page).to have_field(with: 'Tech Lead 3')
    end
  end

  scenario 'User can add and remove multiple departments' do
    within('#multiple_departments') do
      expect(page).to have_selector('.input-group', count: 1)
      find('button', text: '+ add more').click
      find('button', text: '+ add more').click

      all('.input-group input').each_with_index do |input, index|
        input.set("Department #{index + 1}")
      end

      expect(page).to have_selector('.input-group', count: 3)

      all('.input-group-append')[1].click
      expect(page).to have_selector('.input-group', count: 2)
      expect(page).not_to have_field(with: 'Department 2')
      expect(page).to have_field(with: 'Department 1')
      expect(page).to have_field(with: 'Department 3')
    end
  end

  scenario 'User can add and remove multiple product owners' do
    within('#multiple_product_owners') do
      expect(page).to have_selector('.input-group', count: 1)
      find('button', text: '+ add more').click
      find('button', text: '+ add more').click

      all('.input-group input').each_with_index do |input, index|
        input.set("Product Owner #{index + 1}")
      end

      expect(page).to have_selector('.input-group', count: 3)

      all('.input-group-append')[1].click
      expect(page).to have_selector('.input-group', count: 2)
      expect(page).not_to have_field(with: 'Product Owner 2')
      expect(page).to have_field(with: 'Product Owner 1')
      expect(page).to have_field(with: 'Product Owner 3')
    end
  end

  scenario 'User can add and remove multiple admin users' do
    within('#multiple_admin_users') do
      expect(page).to have_selector('.input-group', count: 1)
      find('button', text: '+ add more').click
      find('button', text: '+ add more').click

      all('.input-group input').each_with_index do |input, index|
        input.set("Admin User #{index + 1}")
      end

      expect(page).to have_selector('.input-group', count: 3)

      all('.input-group-append')[1].click
      expect(page).to have_selector('.input-group', count: 2)
      expect(page).not_to have_field(with: 'Admin User 2')
      expect(page).to have_field(with: 'Admin User 1')
      expect(page).to have_field(with: 'Admin User 3')
    end
  end
end
