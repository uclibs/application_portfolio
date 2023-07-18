# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_records/edit', type: :view do
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
                                                  title: 'MyString',
                                                  description: 'MyText',
                                                  status_id: Status.first.id,
                                                  hosting_environment_id: HostingEnvironment.first.id,
                                                  software_type_id: SoftwareType.first.id,
                                                  authentication_type: 'DUO',
                                                  vendor_record_id: VendorRecord.first.id,
                                                  created_by: 'Test User',
                                                  service: 'App Service',
                                                  installed_version: '4.5',
                                                  latest_version: '4.6',
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
                                                  upgrade_status: 'Review',
                                                  who: 'Test Admin',
                                                  semester: 'Fall Quarter 2023',
                                                  upgrade_docs: 'www.example.com'
                                                ))
    session[:previous] = dashboard_path
  end

  it 'renders the edit software_record form' do
    render

    expect(rendered).to have_select('software_record_authentication_type', with_options: %w[DUO LDAP E-Directory Shibboleth Local])

    assert_select 'form[action=?][method=?]', software_record_path(@software_record), 'post' do
      assert_select 'input[name=?]', 'software_record[title]'
      assert_select 'textarea[name=?]', 'software_record[description]'
      assert_select 'select[name=?]', 'software_record[status_id]'
      assert_select 'select[name=?]', 'software_record[software_type_id]'
      assert_select 'select[name=?]', 'software_record[vendor_record_id]'
    end
  end

  it 'renders form tab links' do
    render

    assert_select 'form[action=?][method=?]', software_record_path(@software_record), 'post' do
      assert_select 'a#general-tab'
      assert_select 'a#server-environment-tab'
      assert_select 'a#change-management-tab'
      assert_select 'a#upgrade-history-tab'
    end
  end

  it 'renders the change management form' do
    render

    assert_select 'form[action=?][method=?]', software_record_path(@software_record), 'post' do
      assert_select 'input[name=?]', 'software_record[requires_cm]'
      assert_select 'input[name=?]', 'software_record[last_security_scan]'
      assert_select 'input[name=?]', 'software_record[last_ogc_review]'
      assert_select 'input[name=?]', 'software_record[last_accessibility_scan]'
      assert_select 'input[name=?]', 'software_record[last_info_sec_review]'
      assert_select 'textarea[name=?]', 'software_record[cm_other_notes]'
      assert_select 'textarea[name=?]', 'software_record[cm_stakeholders]'
    end
  end

  it 'renders the server env form' do
    render
    assert_select 'form[action=?][method=?]', software_record_path(@software_record), 'post' do
      assert_select 'textarea[name=?]', 'software_record[qa_url]'
      assert_select 'textarea[name=?]', 'software_record[dev_url]'
      assert_select 'textarea[name=?]', 'software_record[prod_url]'
      assert_select 'textarea[name=?]', 'software_record[production_support_servers]'
      assert_select 'input[name=?]', 'software_record[last_record_change]'
      assert_select 'input[name=?]', 'software_record[track_uptime]'
      assert_select 'input[name=?]', 'software_record[monitor_health]'
      assert_select 'input[name=?]', 'software_record[monitor_errors]'
      assert_select 'input[name=?]', 'software_record[themes]'
      assert_select 'input[name=?]', 'software_record[modules]'
    end
  end

  it 'renders the maintenance log form' do
    render
    assert_select 'form[action=?][method=?]', software_record_path(@software_record), 'post' do
      assert_select 'input[name=?]', 'software_record[service]'
      assert_select 'input[name=?]', 'software_record[installed_version]'
      assert_select 'input[name=?]', 'software_record[proposed_version]'
      assert_select 'input[name=?]', 'software_record[monitor_errors]'
      assert_select 'input[name=?]', 'software_record[priority]'
      assert_select 'input[name=?]', 'software_record[upgrade_status]'
      assert_select 'input[name=?]', 'software_record[who]'
      assert_select 'input[name=?]', 'software_record[semester]'
      assert_select 'input[name=?]', 'software_record[upgrade_docs]'
    end
  end
end
