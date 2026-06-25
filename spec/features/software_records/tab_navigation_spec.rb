# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Software record tab navigation', type: :feature, js: true do
  let(:user) { FactoryBot.create(:admin) }
  let(:software_record) { FactoryBot.create(:software_record, priority: 10) }

  before do
    login_as(user, scope: :user)
  end

  scenario 'opens the maintenance log tab when the edit URL includes a hash' do
    visit "#{edit_software_record_path(software_record)}#maintenance-log"

    expect(page).to have_css('#maintenance-log-tab.nav-link.active')
    expect(page).to have_css('#maintenance-log.tab-pane.active', visible: :all)
    expect(page).to have_no_css('#general-tab.nav-link.active')
    expect(page).to have_no_css('#general.tab-pane.active', visible: :all)
  end

  scenario 'opens the change management tab when the show URL includes a hash' do
    visit "#{software_record_path(software_record)}#change-management"

    expect(page).to have_css('#change-management-tab.nav-link.active')
    expect(page).to have_css('#change-management.tab-pane.active', visible: :all)
  end

  scenario 'activates the hash tab after Turbo navigation from another page' do
    maintenance_log_url = "#{edit_software_record_path(software_record)}#maintenance-log"

    visit software_records_path
    wait_for_turbo
    page.execute_script("Turbo.visit('#{maintenance_log_url}')")

    expect(page).to have_css('#maintenance-log-tab.nav-link.active', wait: 10)
    expect(page.evaluate_script('window.location.hash')).to eq('#maintenance-log')
  end
end
