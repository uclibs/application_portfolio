# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChangeRequestsController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

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
    SoftwareRecord.create!(
      title: 'A Good Software',
      description: 'A Good description about the software',
      status_id: Status.first.id,
      software_type_id: SoftwareType.first.id,
      vendor_record_id: VendorRecord.first.id,
      hosting_environment_id: HostingEnvironment.first.id,
      created_by: 'Test Manager',
      developers: %w[Tester Random],
      tech_leads: ['Lead 1'],
      product_owners: %w[Owner1 Owner2],
      admin_users: %w[Admin1 Admin2]
    )
  end

  let(:valid_session) { {} }

  let(:valid_attributes) do
    {
      change_title: 'A Good Software',
      change_description: 'A Good description about the software',
      software_record_id: 1,
      application_pages: 10,
      number_roles: 3,
      authentication_needed: true,
      custom_error_pages: true
    }
  end

  let(:invalid_attributes) do
    {
      change_title: '',
      change_description: '',
      software_record_id: ''
    }
  end

  def sign_in_user(manager)
    sign_in manager
  end

  describe 'GET #index' do
    it 'returns a success response' do
      expect(response).to be_successful
    end

    it 'assigns @change_requests' do
      # change_request = FactoryBot.create(:change_request)
      # change_request = create(:change_request)
      change_request = ChangeRequest.create! valid_attributes
      get :index
      expect(assigns(:change_requests)).to eq([change_request])
    end

    it 'assigns @change_request_counts' do
      ChangeRequest.create! valid_attributes
      get :index
      expect(assigns(:change_request_counts)).to eq(1)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      # change_request = create(:change_request)
      change_request = ChangeRequest.create! valid_attributes
      get :show, params: { id: change_request.id }
      expect(response).to be_successful
    end

    it 'assigns @change_request' do
      change_request = ChangeRequest.create! valid_attributes
      get :show, params: { id: change_request.id }
      expect(assigns(:change_request)).to eq(change_request)
    end

    it 'assigns @software_name' do
      change_request = ChangeRequest.create! valid_attributes
      software_record = SoftwareRecord.create!(
        title: 'A Good Software',
        description: 'A Good description about the software',
        status_id: Status.first.id,
        software_type_id: SoftwareType.first.id,
        vendor_record_id: VendorRecord.first.id,
        hosting_environment_id: HostingEnvironment.first.id,
        created_by: 'Test Manager',
        developers: %w[Tester Random],
        tech_leads: ['Lead 1'],
        product_owners: %w[Owner1 Owner2],
        admin_users: %w[Admin1 Admin2]
      )
      get :show, params: { id: change_request.id }
      expect(assigns(:software_name)).to eq(software_record.title)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new ChangeRequest to @change_request' do
      get :new
      expect(assigns(:change_request)).to be_a_new(ChangeRequest)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new ChangeRequest' do
        post :create, params: { change_request: valid_attributes }
        expect(response).to redirect_to(ChangeRequest.last)
      end

      it 'redirects to the created change_request' do
        post :create, params: { change_request: valid_attributes }
        expect(response).to redirect_to(ChangeRequest.last)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new ChangeRequest' do
        # post :create, params: { change_request: invalid_attributes }
        expect { post :create, params: { change_request: invalid_attributes } }
          .to_not change(ChangeRequest, :count)
        # expect(response).to_not change(ChangeRequest, :count)
      end

      it 'renders the new template' do
        post :create, params: { change_request: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      change_request = ChangeRequest.create! valid_attributes
      get :edit, params: { id: change_request.id }
      expect(response).to be_successful
    end

    it 'assigns @change_request' do
      change_request = ChangeRequest.create! valid_attributes
      get :edit, params: { id: change_request.id }
      expect(assigns(:change_request)).to eq(change_request)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          change_title: 'A Good Software',
          change_description: 'A Good description about the software',
          software_record_id: 1,
          application_pages: 10,
          number_roles: 3,
          authentication_needed: true,
          custom_error_pages: true
        }
      end

      let(:invalid_attributes) do
        {
          change_title: '',
          change_description: '',
          software_record_id: ''
        }
      end

      it 'updates the requested change_request' do
        change_request = ChangeRequest.create! valid_attributes
        new_title = 'New Change Title'
        patch :update, params: { id: change_request.id, change_request: { change_title: new_title } }
        expect(change_request.reload.change_title).to eq(new_title)
      end

      it 'redirects to the change_request' do
        change_request = ChangeRequest.create! valid_attributes
        new_title = 'New Change Title'
        patch :update, params: { id: change_request.id, change_request: { change_title: new_title } }
        expect(response).to redirect_to(change_request)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the requested change_request' do
        change_request = ChangeRequest.create! valid_attributes
        new_title = nil
        patch :update, params: { id: change_request.id, change_request: { change_title: new_title } }
        expect(change_request.reload.change_title).to_not be_nil
      end

      it 'renders the edit template' do
        change_request = ChangeRequest.create! valid_attributes
        new_title = nil
        patch :update, params: { id: change_request.id, change_request: { change_title: new_title } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested change_request' do
      change_request = ChangeRequest.create! valid_attributes
      expect do
        delete :destroy, params: { id: change_request.id }
      end.to change(ChangeRequest, :count).by(-1)
    end

    it 'redirects to the change_requests index' do
      change_request = ChangeRequest.create! valid_attributes
      delete :destroy, params: { id: change_request.id }
      expect(response).to redirect_to(change_requests_url)
    end
  end
end
