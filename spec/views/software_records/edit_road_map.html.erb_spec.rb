# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_records/edit_road_map', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:admin) })
    VendorRecord.create!(
      title: 'Vendor 1',
      description: 'test vendor'
    )
    SoftwareType.create!(
      title: 'Web app',
      description: 'test software type'
    )
    Status.create!(
      title: 'Test',
      status_type: 'Design'
    )
    HostingEnvironment.create!(
      title: 'Test Env.',
      description: 'test env.'
    )
    @software_record = assign(:software_record, SoftwareRecord.create!(
                                                  title: 'MyTitle',
                                                  description: 'MyText',
                                                  status_id: Status.first.id,
                                                  hosting_environment_id: HostingEnvironment.first.id,
                                                  software_type_id: SoftwareType.first.id,
                                                  authentication_type: 'DUO',
                                                  vendor_record_id: VendorRecord.first.id,
                                                  created_by: 'Test User',
                                                  service: 'App Service',
                                                  installed_version: '4.5',
                                                  proposed_version: '4.4',
                                                  last_upgrade_date: '2020-02-02',
                                                  upgrade_available: true,
                                                  vulnerabilities_reported: true,
                                                  vulnerabilities_fixed: true,
                                                  bug_fixes: true,
                                                  new_features: true,
                                                  breaking_changes: true,
                                                  end_of_life: true,
                                                  priority: '10',
                                                  road_map: 'Road Map',
                                                  upgrade_status: 'Review',
                                                  who: 'Test Admin',
                                                  semester: 'Fall Quarter 2023',
                                                  upgrade_docs: 'www.example.com'
                                                ))
    session[:previous] = dashboard_path
  end

  it 'displays the Edit Road Map form' do
    render

    expect(rendered).to have_css('h1.text-center', text: 'Edit Road Map')
    expect(rendered).to have_css('form')
    expect(rendered).to have_field('software_record_road_map', with: 'Road Map')
    expect(rendered).to have_css('p.form-control-plaintext.text-white', text: 'MyTitle')
    expect(rendered).to have_button('Update')
    expect(rendered).to have_link('Back', href: software_records_path)
  end
end
