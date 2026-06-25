# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Dashboard navigation menu', type: :feature, js: true do
  let(:user) { FactoryBot.create(:admin) }

  before { login_as(user, scope: :user) }

  scenario 'opens and closes the sidenav via Stimulus actions' do
    visit dashboard_path

    find('#dashboard-open').click
    expect(page.evaluate_script("document.getElementById('mySidenav').style.visibility")).to eq('visible')
    expect(page.evaluate_script("document.getElementById('mySidenav').style.width")).to eq('250px')

    find('.closebtn').click
    expect(page.evaluate_script("document.getElementById('mySidenav').style.visibility")).to eq('hidden')
    expect(page.evaluate_script("document.getElementById('mySidenav').style.width")).to eq('0px')
  end

  scenario 'resets the sidenav after Turbo navigation' do
    visit dashboard_path

    find('#dashboard-open').click
    expect(page.evaluate_script("document.getElementById('mySidenav').style.visibility")).to eq('visible')

    page.execute_script("Turbo.visit('#{software_records_path}')")
    expect(page).to have_current_path(software_records_path, ignore_query: true, wait: 10)
    expect(page.evaluate_script("document.getElementById('mySidenav').style.visibility")).to eq('hidden')
  end
end
