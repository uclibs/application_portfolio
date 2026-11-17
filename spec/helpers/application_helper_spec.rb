# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#user_display_name' do
    let(:user) { FactoryBot.build(:admin, first_name: 'Admin', last_name: 'User') }

    it 'joins the user first and last name' do
      expect(helper.user_display_name(user)).to eq('Admin User')
    end

    it 'omits blank name parts' do
      user.last_name = ''
      expect(helper.user_display_name(user)).to eq('Admin')
    end

    it 'uses the signed-in user when no user is passed' do
      signed_in = user
      helper.define_singleton_method(:current_user) { signed_in }

      expect(helper.user_display_name).to eq('Admin User')
    end

    it 'returns an empty string when there is no user' do
      expect(helper.user_display_name(nil)).to eq('')
    end
  end

  describe '#nav_helper' do
    let(:user) { FactoryBot.build(:admin, first_name: 'Admin', last_name: 'User') }

    before do
      allow(helper.request).to receive(:get?).and_return(true)
      allow(helper.request).to receive(:path).and_return(dashboard_path)
      allow(helper.request).to receive(:script_name).and_return('')
    end

    it 'links a signed-in user to the dashboard and marks the current page' do
      signed_in = user
      helper.define_singleton_method(:current_user) { signed_in }

      html = helper.nav_helper('nav-link')

      expect(html).to include('Dashboard')
      expect(html).to include('About')
      expect(html).to include('Contact')
      expect(html).to include('active')
      expect(html).not_to include('Login')
    end

    it 'links a guest to the local sign-in page' do
      helper.define_singleton_method(:current_user) { nil }
      allow(Rails.configuration.x.auth).to receive(:shibboleth_enabled).and_return(false)

      html = helper.nav_helper('nav-link')

      expect(html).to include('Request Software')
      expect(html).to include(new_user_session_path)
      expect(html).not_to include('Shibboleth.sso')
    end

    it 'links a guest to Shibboleth when campus sign-in is enabled' do
      helper.define_singleton_method(:current_user) { nil }
      allow(Rails.configuration.x.auth).to receive(:shibboleth_enabled).and_return(true)

      html = helper.nav_helper('nav-link')

      expect(html).to include('/Shibboleth.sso/Login?target=%2Fauth%2Fshibboleth&amp;forceAuthn=1')
    end
  end

  describe '#shibboleth_force_authn_login_path' do
    it 'escapes the return path, including a mounted script name' do
      allow(helper.request).to receive(:script_name).and_return('/portfolio')

      expect(helper.shibboleth_force_authn_login_path)
        .to eq('/Shibboleth.sso/Login?target=%2Fportfolio%2Fauth%2Fshibboleth&forceAuthn=1')
    end
  end

  describe '#active?' do
    before do
      allow(helper.request).to receive(:get?).and_return(true)
      allow(helper.request).to receive(:path).and_return(about_path)
    end

    it 'returns active on the current page and nil elsewhere' do
      expect(helper.active?(about_path)).to eq('active')
      expect(helper.active?(contact_path)).to be_nil
    end
  end

  describe '#generate_path' do
    it 'leaves an http or https url unchanged' do
      expect(helper.generate_path('https://example.edu')).to eq('https://example.edu')
      expect(helper.generate_path('http://example.edu')).to eq('http://example.edu')
    end

    it 'prefixes a host that has no scheme' do
      expect(helper.generate_path('example.edu')).to eq('http://example.edu')
      expect(helper.generate_path(nil)).to eq('http://')
    end
  end

  describe '#clean_url' do
    it 'removes an https scheme' do
      expect(helper.clean_url('https://example.edu/app')).to eq('example.edu/app')
    end

    it 'removes an http scheme' do
      expect(helper.clean_url('http://example.edu/app')).to eq('example.edu/app')
    end

    it 'leaves a host that has no scheme unchanged' do
      expect(helper.clean_url('example.edu/app')).to eq('example.edu/app')
      expect(helper.clean_url(nil)).to eq('')
    end
  end

  describe '#navigation' do
    it 'records the first url, moves it to previous when the url changes, and keeps it when the url repeats' do
      allow(helper.request).to receive(:original_url).and_return('http://example.test/dashboard')

      helper.navigation

      expect(controller.session[:previous]).to eq('http://example.test/dashboard')
      expect(controller.session[:current]).to eq('http://example.test/dashboard')

      helper.navigation

      expect(controller.session[:previous]).to eq('http://example.test/dashboard')

      allow(helper.request).to receive(:original_url).and_return('http://example.test/about')
      helper.navigation

      expect(controller.session[:previous]).to eq('http://example.test/dashboard')
      expect(controller.session[:current]).to eq('http://example.test/about')
    end
  end

  describe 'generate_software_records_series' do
    let(:status) { FactoryBot.create(:status) }
    let(:hosting_environment) { FactoryBot.create(:hosting_environment) }
    let(:software_type) { FactoryBot.create(:software_type) }
    let(:vendor_record) { FactoryBot.create(:vendor_record) }
    let!(:software_record) { FactoryBot.create(:software_record, vendor_record_id: vendor_record.id, software_type_id: software_type.id, status_id: status.id, hosting_environment_id: hosting_environment.id) }
    let!(:software_record_old) { FactoryBot.create(:software_record, created_at: '1968-01-01', vendor_record_id: vendor_record.id, software_type_id: software_type.id, status_id: status.id, hosting_environment_id: hosting_environment.id) }

    it 'returns a monotonically increasing series through the current month' do
      # June leaves July through December unvisited, so the month loop can break.
      allow(Date).to receive(:today).and_return(Date.new(2026, 6, 15))

      graph_values = generate_software_records_series
      data = graph_values[0][:data]
      values = data.values

      expect(values.first).to be > 0
      expect(values).to eq(values.sort)
      expect(data.keys).to include('June, 2026')
      expect(data.keys).not_to include('July, 2026')
    end
  end
end
