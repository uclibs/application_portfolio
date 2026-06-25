# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Software records filter management', type: :feature, js: true do
  let(:user) { FactoryBot.create(:admin) }

  before { login_as(user, scope: :user) }

  scenario 'toggles vendor and software type filter panels client-side' do
    visit software_records_path

    find('#vrecords').click
    expect(page.evaluate_script("document.getElementById('vendor-record-filter').style.display")).to eq('block')
    expect(page.evaluate_script("document.getElementById('software-type-filter').style.display")).to eq('none')

    find('#stypes').click
    expect(page.evaluate_script("document.getElementById('software-type-filter').style.display")).to eq('block')
    expect(page.evaluate_script("document.getElementById('vendor-record-filter').style.display")).to eq('none')
  end
end
