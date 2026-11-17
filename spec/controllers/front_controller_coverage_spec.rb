# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FrontController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:admin) { FactoryBot.create(:admin) }

  before { sign_in admin }

  # The layout reads the global $page_title. Ruby 4 has no global_variable_get.
  def page_title
    eval('$page_title', binding, __FILE__, __LINE__)
  end

  describe 'GET #index' do
    it 'sets the welcome title' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(page_title).to eq('Welcome | UCL Application Portfolio')
    end
  end

  describe 'GET #about' do
    it 'sets the about title' do
      get :about

      expect(response).to have_http_status(:ok)
      expect(page_title).to eq('About Us | UCL Application Portfolio')
    end
  end

  describe 'GET #contact' do
    it 'sets the contact title' do
      get :contact

      expect(response).to have_http_status(:ok)
      expect(page_title).to eq('Contact Us | UCL Application Portfolio')
    end
  end

  describe 'GET #profile' do
    it 'lists users' do
      get :profile

      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).to include(admin)
    end
  end

  describe 'GET #new' do
    it 'starts a software request' do
      get :new

      expect(response).to have_http_status(:ok)
      expect(assigns(:requestnewsoftwares)).to be_a_new(SoftwareRecord)
    end
  end

  describe 'GET #dashboard' do
    it 'counts each queue for the signed-in user' do
      get :dashboard, params: { sort: 'title', direction: 'desc' }

      expect(response).to have_http_status(:ok)
      expect(assigns(:user)).to eq('Random Admin')
      expect(assigns(:indesign_count)).to eq(0)
      expect(assigns(:production_count)).to eq(0)
      expect(assigns(:inchange_count)).to eq(0)
      expect(assigns(:softwarerecords_indesign).to_sql).to match(/title.*desc/i)
    end

    it 'falls back to title ascending when the sort params are not columns' do
      get :dashboard, params: { sort: 'not_a_column', direction: 'sideways' }

      expect(assigns(:softwarerecords_indesign).to_sql).to match(/title\s+asc/i)
      expect(assigns(:softwarerecords_production).to_sql).to match(/title\s+asc/i)
      expect(assigns(:softwarerecords_inchange).to_sql).to match(/title\s+asc/i)
    end

    it 'uses zero when a dashboard count raises' do
      scope = SoftwareRecord.none
      allow(scope).to receive(:order).and_return(scope)
      allow(scope).to receive(:count).and_raise(StandardError, 'count failed')
      allow(SoftwareRecordsController).to receive_messages(
        indesign_dashboard: scope,
        production_dashboard: scope,
        inchange_dashboard: scope
      )

      get :dashboard

      expect(assigns(:indesign_count)).to eq(0)
      expect(assigns(:production_count)).to eq(0)
      expect(assigns(:inchange_count)).to eq(0)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #search' do
    let(:active_status) { FactoryBot.create(:status, title: 'Live', status_type: 'Active') }
    let(:retired_status) { FactoryBot.create(:status, title: 'Retired', status_type: 'Decommissioned') }
    let(:portal_vendor) { FactoryBot.create(:vendor_record, title: 'Portal Vendor') }
    let(:portal_type) { FactoryBot.create(:software_type, title: 'Portal Type') }

    before do
      FactoryBot.create(:software_record, title: 'Portal', status: active_status, vendor_record: portal_vendor,
                                          software_type: portal_type)
      FactoryBot.create(:software_record, title: 'Portal Retired', status: retired_status, vendor_record: portal_vendor,
                                          software_type: portal_type)
      FactoryBot.create(:vendor_record, title: 'Other Vendor')
      FactoryBot.create(:software_type, title: 'Other Type')
    end

    it 'matches software, vendors, and types without decommissioned software' do
      get :search, params: { search: 'PORTAL' }

      expect(response).to have_http_status(:ok)
      expect(assigns(:parameter)).to eq('portal')
      expect(assigns(:softwarerecords_results).pluck(:title)).to eq(['Portal'])
      expect(assigns(:vendorrecords_results).pluck(:title)).to eq(['Portal Vendor'])
      expect(assigns(:softwaretypes_results).pluck(:title)).to eq(['Portal Type'])
    end

    it 'redirects when the search is blank' do
      get :search, params: { search: '   ' }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Cannot search on empty field!')
    end
  end

  describe 'POST #create' do
    it 'redirects back to the request form when the record is invalid' do
      expect do
        post :create, params: { software_record: { title: '' } }
      end.not_to change(SoftwareRecord, :count)

      expect(response).to redirect_to(request_new_path)
      expect(assigns(:requestnewsoftwares)).not_to be_persisted
    end
  end
end
