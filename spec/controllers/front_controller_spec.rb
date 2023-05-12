# frozen_string_literal: true

require 'rails_helper'

describe FrontController do
  include Devise::Test::ControllerHelpers
  render_views

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}
      expect(response).to be_successful
      expect(response).to render_template(:new)
    end
  end

  describe '#index' do
    it 'renders the index page' do
      get :index
      expect(response.status).to eq(200)
      expect(response).to render_template('index')
    end
  end

  describe '#about' do
    it 'renders the about page' do
      get :about
      expect(response.status).to eq(200)
      expect(response).to render_template('about')
    end
  end

  describe '#contact' do
    it 'renders the contact page' do
      get :contact
      expect(response.status).to eq(200)
      expect(response).to render_template('contact')
    end
  end

  describe '#dashboard' do
    def sign_in_user(admin)
      sign_in admin
    end

    before do
      admin = FactoryBot.create(:admin)
      sign_in_user(admin)
    end

    it 'renders the dashboard page' do
      get :dashboard
      expect(response.status).to eq(200)
      expect(response).to render_template('dashboard')
    end
  end

  describe '#profile' do
    def sign_in_user(admin)
      sign_in admin
    end

    before do
      admin = FactoryBot.create(:admin)
      sign_in_user(admin)
    end

    it 'renders the profile page' do
      get :profile
      expect(response.status).to eq(200)
      expect(response).to render_template('profile')
    end
  end

  describe '#search' do
    before do
      admin = FactoryBot.create(:admin)
      sign_in_user(admin)

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
    end

    let(:valid_session) { {} }

    let(:valid_attributes) do
      {
        title: 'A Good Software',
        description: 'A Good description about the software',
        status_id: Status.first.id,
        software_type_id: SoftwareType.first.id,
        vendor_record_id: VendorRecord.first.id,
        hosting_environment_id: HostingEnvironment.first.id,
        created_by: 'Test Admin',
        developers: %w[Tester Random],
        tech_leads: ['Lead 1'],
        product_owners: %w[Owner1 Owner2],
        admin_users: %w[Admin1 Admin2]
      }
    end

    def sign_in_user(admin)
      sign_in admin
    end

    it 'renders the correct search data' do
      SoftwareRecord.create! valid_attributes
      get :search, params: { search: 'good' }, session: valid_session
      expect(response.body).to have_content('A Good Software')
    end

    it 'redirects to root_path when search param is blank' do
      SoftwareRecord.create! valid_attributes
      get :search, params: { search: '' }, session: valid_session
      expect(response).to redirect_to(root_path)
    end
  end
end
