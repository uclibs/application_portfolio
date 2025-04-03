# frozen_string_literal: true

RSpec.describe FrontController, type: :controller do
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

  describe '#create' do
    def sign_in_user(admin)
      sign_in admin
    end

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

    let(:software_record_params) do
      {
        software_record: {

          title: 'A Good Software',
          description: 'A Good description about the software',
          status_id: Status.first.id,
          software_type_id: SoftwareType.first.id,
          vendor_record_id: VendorRecord.first.id,
          created_by: 'Test Admin',
          developers: %w[Tester Random],
          tech_leads: ['Lead 1'],
          product_owners: %w[Owner1 Owner2],
          admin_users: %w[Admin1 Admin2],
          hosting_environment_id: HostingEnvironment.first.id,
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
          upgrade_status: 'Review',
          who: 'Test Admin',
          semester: 'Fall Quarter 2023',
          upgrade_docs: 'www.example.com'

        }
      }
    end

    context 'when the software record is successfully saved' do
      before do
        post :create, params: software_record_params
      end
    end

    context 'when the software record fails to save' do
      before do
        allow_any_instance_of(SoftwareRecord).to receive(:save).and_return(false)
        post :create, params: software_record_params
      end

      it 'does not create a new software record' do
        expect(assigns(:requestnewsoftwares)).to be_an_instance_of(SoftwareRecord)
        expect(assigns(:requestnewsoftwares)).not_to be_persisted
      end

      it 'redirects to the request_new path' do
        expect(response).to redirect_to(request_new_path)
      end
    end
  end

  describe '#search' do
    before do
      admin = FactoryBot.create(:admin)
      sign_in admin

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

    context 'when search term is provided' do
      let(:search_term) { 'example' }

      before do
        get :search, params: { search: search_term }
      end

      it 'returns HTTP success' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns the results to instance variables' do
        expect(assigns(:softwarerecords_results)).to be_a(ActiveRecord::Relation)
        expect(assigns(:vendorrecords_results)).to be_a(ActiveRecord::Relation)
        expect(assigns(:softwaretypes_results)).to be_a(ActiveRecord::Relation)
      end
    end

    context 'when search term is blank' do
      before do
        get :search, params: { search: '' }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash alert message' do
        expect(flash[:alert]).to eq('Cannot search on empty field!')
      end
    end
  end
end
