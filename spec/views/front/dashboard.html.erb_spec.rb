# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'front/dashboard', type: :view do
  before(:each) do
    @softwarerecords_indesign = SoftwareRecordsController.indesign_dashboard
    @softwarerecords_production = SoftwareRecordsController.production_dashboard
  end

  it 'displays an dashboard page' do
    render
    expect(rendered).to have_text('Users')
    expect(rendered).to have_text('Software Records')
    expect(rendered).to have_text('Software Types')
    expect(rendered).to have_text('Vendor Records')
  end
end
