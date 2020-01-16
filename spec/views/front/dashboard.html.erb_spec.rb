# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'front/dashboard', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:admin) })
    admin = FactoryBot.build(:admin)
    @softwarerecords_indesign = SoftwareRecordsController.indesign_dashboard(admin)
    @softwarerecords_production = SoftwareRecordsController.production_dashboard(admin)
  end

  it 'displays an dashboard page' do
    render
    expect(rendered).to have_text('Users')
    expect(rendered).to have_text('My Software Records In-Design/Development')
    expect(rendered).to have_text('My Software Records In Production')
    expect(rendered).to have_text('Software Records')
    expect(rendered).to have_text('Vendor Records')
  end
end
