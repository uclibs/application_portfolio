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
                                                  monitor_errors: 'Yes'
                                                ))
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:viewer) })
    session[:previous] = dashboard_path
  end

  it 'renders general attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
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
end
