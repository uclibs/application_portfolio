# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_records/show', type: :view do
  let(:now) { Time.now.strftime('%Y/%m/%d') }
  before(:each) do
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
                                                  requires_cm: 'Yes',
                                                  last_security_scan: now,
                                                  last_accessibility_scan: now,
                                                  last_ogc_review: now,
                                                  last_info_sec_review: now,
                                                  cm_stakeholders: 'me, you',
                                                  cm_other_notes: 'other text',
                                                  qa_url: 'http://qa.com',
                                                  dev_url: 'http://dev.com',
                                                  prod_url: 'http://prod.comm',
                                                  production_support_servers: 'servers listed',
                                                  last_record_change: now,
                                                  track_uptime: 'Yes',
                                                  monitor_health: 'Yes',
                                                  monitor_errors: 'Yes',
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
                                                  when: 'Fall Quarter 2023',
                                                  upgrade_docs: 'www.example.com'
                                                ))
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:viewer) })
    session[:previous] = dashboard_path
  end

  it 'renders general attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/DUO/)
  end

  it 'renders change management attributes in <p>' do
    render
    expect(rendered).to match(/Last accessibility scan:/)
  end

  it 'renders tabbed view' do
    render
    expect(rendered).to match(/General/)
    expect(rendered).to match(/Server Environment/)
    expect(rendered).to match(/Change Management/)
    expect(rendered).to match(/Upgrade History/)
  end

  it 'renders change management values' do
    render
    expect(rendered).to match(/Requires Change Management review/)
    expect(rendered).to match(/Last security scan/)
    expect(rendered).to match(/Last accessibility scan/)
    expect(rendered).to match(/Last OGC review/)
    expect(rendered).to match(/Last Infosec review/)
    expect(rendered).to match(/CM stakeholders/)
    expect(rendered).to match(/CM other notes/)
  end

  it 'renders server env values' do
    render
    expect(rendered).to match(/QA URL/)
    expect(rendered).to match(/Dev URL/)
    expect(rendered).to match(/Production URL/)
    expect(rendered).to match(/Production support servers/)
    expect(rendered).to match(/Last record change/)
    expect(rendered).to match(/Track uptime/)
    expect(rendered).to match(/Monitor health/)
    expect(rendered).to match(/Monitor errors/)
  end

  it 'renders maintenance log values' do
    render
    expect(rendered).to match(/Name of Service/)
    expect(rendered).to match(/Current Version/)
    expect(rendered).to match(/Latest version available/)
    expect(rendered).to match(/Next Proposed version/)
    expect(rendered).to match(/Last Upgrade Date/)
    expect(rendered).to match(/Is there an upgrade available/)
    expect(rendered).to match(/Are there vulnerabilities reported/)
    expect(rendered).to match(/Does the new version fix vulnerabilities/)
    expect(rendered).to match(/Are there bug fixes reported/)
    expect(rendered).to match(/Are there any new features/)
    expect(rendered).to match(/Are there any breaking changes/)
    expect(rendered).to match(/Is this an end of life version/)
    expect(rendered).to match(/Is this a priority/)
    expect(rendered).to match(/What is the status/)
    expect(rendered).to match(/Who is responsible/)
    expect(rendered).to match(/When is this scheduled for/)
    expect(rendered).to match(/Are there any ugprade links/)
  end
end
