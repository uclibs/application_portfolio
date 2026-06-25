# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'dashboard contrast styles' do
  let(:contrast_scss) { Rails.root.join('app/assets/stylesheets/_dashboard_contrast.scss').read }
  let(:software_records_scss) { Rails.root.join('app/assets/stylesheets/software_records.scss').read }

  it 'keeps form labels readable on black card-detail surfaces' do
    expect(contrast_scss).to include('.card-detail[style*="background-color: black"]')
    expect(contrast_scss).to match(/\.card-detail\[style\*="background-color: black"\][\s\S]*\.tab-pane[\s\S]*color:\s*#fff/)
    expect(contrast_scss).to match(/\.card-detail\[style\*="background-color: black"\][\s\S]*label[\s\S]*color:\s*#fff/)
  end

  it 'keeps active tab labels readable on black card surfaces' do
    expect(contrast_scss).to match(/\.nav-tabs \.nav-link\.active[\s\S]*color:\s*#212529/)
    expect(contrast_scss).to match(/\.nav-tabs \.nav-link\.active[\s\S]*background-color:\s*#fff/)
    expect(contrast_scss).to match(/\.nav-tabs \.nav-link[\s\S]*color:\s*#fff/)
  end

  it 'loads contrast rules in the software_records stylesheet entry point' do
    expect(software_records_scss).to include('@use "dashboard_contrast"')
    expect(software_records_scss).to match(/div\.active\.tab-pane[\s\S]*label[\s\S]*color:\s*#fff/)
  end
end
