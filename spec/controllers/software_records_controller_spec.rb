# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe SoftwareRecordsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # SoftwareRecord. As you add validations to SoftwareRecord, be sure to
  # adjust the attributes here as well.
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
  end

  let(:valid_attributes) do
    {
      title: 'A Good Software',
      description: 'A Good description about the software',
      status: 'In Development',
      software_type_id: SoftwareType.first.id,
      vendor_record_id: VendorRecord.first.id,
      created_by: 'Test Admin',
      developers: %w[Tester Random],
      tech_leads: ['Lead 1'],
      product_owners: %w[Owner1 Owner2]
    }
  end

  let(:invalid_attributes) do
    {
      title: '',
      description: '',
      status: '',
      software_type_id: '',
      vendor_record_id: ''
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SoftwareRecordsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  def sign_in_user(admin)
    sign_in admin
  end

  describe 'GET #index' do
    it 'returns a success response' do
      SoftwareRecord.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it 'has the correct content' do
      SoftwareRecord.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response.body).to match('\b(A.Good.Software)\b')
      expect(response.body).to_not have_content('In Development')
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      software_record = SoftwareRecord.create! valid_attributes
      get :show, params: { id: software_record.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response.body).to have_content('A Good Software')
      expect(response.body).to have_content('In Development')
      expect(response.body).to have_content('Test Admin')
      expect(response.body).to have_content('Tester')
      expect(response.body).to have_content('Random')
      expect(response.body).to have_content('Lead 1')
      expect(response.body).to have_content('Owner1')
      expect(response.body).to have_content('Owner2')
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      software_record = SoftwareRecord.create! valid_attributes
      get :edit, params: { id: software_record.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new SoftwareRecord' do
        expect do
          post :create, params: { software_record: valid_attributes }, session: valid_session
        end.to change(SoftwareRecord, :count).by(1)
      end

      it 'redirects to the created software_record' do
        post :create, params: { software_record: valid_attributes }, session: valid_session
        expect(response).to redirect_to(SoftwareRecord.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { software_record: invalid_attributes }, session: valid_session
        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { title: 'A Great Software v2.0', description: 'An Updated good description of the software', status: 'To be decomissioned' }
      end

      it 'updates the requested software_record' do
        software_record = SoftwareRecord.create! valid_attributes
        put :update, params: { id: software_record.to_param, software_record: new_attributes }, session: valid_session
        software_record.reload
        expect(software_record.title).to eq('A Great Software v2.0')
        expect(software_record.description).to eq('An Updated good description of the software')
        expect(software_record.status).to eq('To be decomissioned')
        expect(software_record.created_by).to eq('Test Admin')
        expect(software_record.developers).to eq(%w[Tester Random])
        expect(software_record.tech_leads).to eq(['Lead 1'])
        expect(software_record.product_owners).to eq(%w[Owner1 Owner2])
      end

      it 'redirects to the software_record' do
        software_record = SoftwareRecord.create! valid_attributes
        put :update, params: { id: software_record.to_param, software_record: valid_attributes }, session: valid_session
        expect(response).to redirect_to(software_record)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        software_record = SoftwareRecord.create! valid_attributes
        put :update, params: { id: software_record.to_param, software_record: invalid_attributes }, session: valid_session
        expect(response).to be_successful
        expect(response).to render_template(:edit)
        expect(response.body).to have_content("Title can\\'t be blank")
        expect(response.body).to have_content("Description can\\'t be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested software_record' do
      software_record = SoftwareRecord.create! valid_attributes
      expect do
        delete :destroy, params: { id: software_record.to_param }, session: valid_session
      end.to change(SoftwareRecord, :count).by(-1)
    end

    it 'redirects to the software_records list' do
      session[:previous] = software_records_url
      software_record = SoftwareRecord.create! valid_attributes
      delete :destroy, params: { id: software_record.to_param }, session: valid_session
      expect(response).to redirect_to(session[:previous])
    end
  end
end

# viewer specs

RSpec.describe SoftwareRecordsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # SoftwareRecord. As you add validations to SoftwareRecord, be sure to
  # adjust the attributes here as well.
  include Devise::Test::ControllerHelpers
  render_views

  before do
    viewer = FactoryBot.create(:viewer)
    sign_in_user(viewer)

    VendorRecord.create!(
      title: 'Vendor 1',
      description: 'test vendor'
    )
    SoftwareType.create!(
      title: 'Web app',
      description: 'test software type'
    )
  end

  let(:valid_attributes) do
    {
      title: 'A Good Software',
      description: 'A Good description about the software',
      status: 'In Development',
      software_type_id: SoftwareType.first.id,
      vendor_record_id: VendorRecord.first.id,
      created_by: 'Test Viewer',
      developers: %w[Tester Random],
      tech_leads: ['Lead 1'],
      product_owners: %w[Owner1 Owner2]
    }
  end

  let(:invalid_attributes) do
    {
      title: '',
      description: '',
      status: '',
      software_type_id: '',
      vendor_record_id: ''
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SoftwareRecordsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  def sign_in_user(viewer)
    sign_in viewer
  end

  describe 'GET #index' do
    it 'returns a success response' do
      SoftwareRecord.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it 'has the correct content' do
      SoftwareRecord.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response.body).to match('\b(A.Good.Software)\b')
      expect(response.body).to_not have_content('In Development')
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      software_record = SoftwareRecord.create! valid_attributes
      get :show, params: { id: software_record.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response.body).to have_content('A Good Software')
      expect(response.body).to have_content('In Development')
      expect(response.body).not_to have_content('Test Viewer')
      expect(response.body).to have_content('Tester')
      expect(response.body).to have_content('Random')
      expect(response.body).to have_content('Lead 1')
      expect(response.body).to have_content('Owner1')
      expect(response.body).to have_content('Owner2')
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to_not be_successful
      expect(response).to_not render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      software_record = SoftwareRecord.create! valid_attributes
      get :edit, params: { id: software_record.to_param }, session: valid_session
      expect(response).to_not be_successful
      expect(response).to_not render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new SoftwareRecord' do
        expect do
          post :create, params: { software_record: valid_attributes }, session: valid_session
        end.to change(SoftwareRecord, :count).by(1)
      end

      it 'redirects to the created software_record' do
        post :create, params: { software_record: valid_attributes }, session: valid_session
        expect(response).to redirect_to(SoftwareRecord.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { software_record: invalid_attributes }, session: valid_session
        expect(response).to_not be_successful
        expect(response).to redirect_to '/request/new'
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { title: 'A Great Software v2.0', description: 'An Updated good description of the software', status: 'To be decomissioned' }
      end

      it 'updates the requested software_record' do
        software_record = SoftwareRecord.create! valid_attributes
        put :update, params: { id: software_record.to_param, software_record: new_attributes }, session: valid_session
        software_record.reload
        expect(software_record.title).to_not eq('A Great Software v2.0')
        expect(software_record.description).to_not eq('An Updated good description of the software')
        expect(software_record.status).to_not eq('To be decomissioned')
        expect(software_record.developers).to eq(%w[Tester Random])
        expect(software_record.tech_leads).to eq(['Lead 1'])
        expect(software_record.product_owners).to eq(%w[Owner1 Owner2])
      end

      it 'redirects to the software_record' do
        software_record = SoftwareRecord.create! valid_attributes
        put :update, params: { id: software_record.to_param, software_record: valid_attributes }, session: valid_session
        expect(response).to_not redirect_to(software_record)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        software_record = SoftwareRecord.create! valid_attributes
        put :update, params: { id: software_record.to_param, software_record: invalid_attributes }, session: valid_session
        expect(response).to_not be_successful
        expect(response).to_not render_template(:edit)
        expect(response.body).to_not have_content("Title can\\'t be blank")
        expect(response.body).to_not have_content("Description can\\'t be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested software_record' do
      software_record = SoftwareRecord.create! valid_attributes
      expect do
        delete :destroy, params: { id: software_record.to_param }, session: valid_session
      end.to change(SoftwareRecord, :count).by(0)
    end

    it 'redirects to the software_records list' do
      software_record = SoftwareRecord.create! valid_attributes
      delete :destroy, params: { id: software_record.to_param }, session: valid_session
      expect(response).to_not redirect_to(software_records_url)
    end
  end
end

# manager specs

RSpec.describe SoftwareRecordsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # SoftwareRecord. As you add validations to SoftwareRecord, be sure to
  # adjust the attributes here as well.
  include Devise::Test::ControllerHelpers
  render_views

  before do
    manager = FactoryBot.create(:manager)
    sign_in_user(manager)

    VendorRecord.create!(
      title: 'Vendor 1',
      description: 'test vendor'
    )
    SoftwareType.create!(
      title: 'Web app',
      description: 'test software type'
    )
  end

  let(:valid_attributes) do
    {
      title: 'A Good Software',
      description: 'A Good description about the software',
      status: 'In Development',
      software_type_id: SoftwareType.first.id,
      vendor_record_id: VendorRecord.first.id,
      created_by: 'Test Manager',
      developers: %w[Tester Random],
      tech_leads: ['Lead 1'],
      product_owners: %w[Owner1 Owner2]
    }
  end

  let(:invalid_attributes) do
    {
      title: '',
      description: '',
      status: '',
      software_type_id: '',
      vendor_record_id: ''
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SoftwareRecordsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  def sign_in_user(manager)
    sign_in manager
  end

  describe 'GET #index' do
    it 'returns a success response' do
      SoftwareRecord.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it 'has the correct content' do
      SoftwareRecord.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response.body).to match('\b(A.Good.Software)\b')
      expect(response.body).to_not have_content('In Development')
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      software_record = SoftwareRecord.create! valid_attributes
      get :show, params: { id: software_record.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response.body).to have_content('A Good Software')
      expect(response.body).to have_content('In Development')
      expect(response.body).not_to have_content('Test Manager')
      expect(response.body).to have_content('Tester')
      expect(response.body).to have_content('Random')
      expect(response.body).to have_content('Lead 1')
      expect(response.body).to have_content('Owner1')
      expect(response.body).to have_content('Owner2')
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      software_record = SoftwareRecord.create! valid_attributes
      get :edit, params: { id: software_record.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new SoftwareRecord' do
        expect do
          post :create, params: { software_record: valid_attributes }, session: valid_session
        end.to change(SoftwareRecord, :count).by(1)
      end

      it 'redirects to the created software_record' do
        post :create, params: { software_record: valid_attributes }, session: valid_session
        expect(response).to redirect_to(SoftwareRecord.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { software_record: invalid_attributes }, session: valid_session
        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { title: 'A Great Software v2.0', description: 'An Updated good description of the software', status: 'To be decomissioned' }
      end

      it 'updates the requested software_record' do
        software_record = SoftwareRecord.create! valid_attributes
        put :update, params: { id: software_record.to_param, software_record: new_attributes }, session: valid_session
        software_record.reload
        expect(software_record.title).to eq('A Great Software v2.0')
        expect(software_record.description).to eq('An Updated good description of the software')
        expect(software_record.status).to eq('To be decomissioned')
        expect(software_record.created_by).to eq('Test Manager')
        expect(software_record.developers).to eq(%w[Tester Random])
        expect(software_record.tech_leads).to eq(['Lead 1'])
        expect(software_record.product_owners).to eq(%w[Owner1 Owner2])
      end

      it 'redirects to the software_record' do
        software_record = SoftwareRecord.create! valid_attributes
        put :update, params: { id: software_record.to_param, software_record: valid_attributes }, session: valid_session
        expect(response).to redirect_to(software_record)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        software_record = SoftwareRecord.create! valid_attributes
        put :update, params: { id: software_record.to_param, software_record: invalid_attributes }, session: valid_session
        expect(response).to be_successful
        expect(response).to render_template(:edit)
        expect(response.body).to have_content("Title can\\'t be blank")
        expect(response.body).to have_content("Description can\\'t be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested software_record' do
      software_record = SoftwareRecord.create! valid_attributes
      expect do
        delete :destroy, params: { id: software_record.to_param }, session: valid_session
      end.to change(SoftwareRecord, :count).by(-1)
    end

    it 'redirects to the software_records list' do
      session[:previous] = software_records_url
      software_record = SoftwareRecord.create! valid_attributes
      delete :destroy, params: { id: software_record.to_param }, session: valid_session
      expect(response).to redirect_to(session[:previous])
    end
  end
end

# owner specs

RSpec.describe SoftwareRecordsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # SoftwareRecord. As you add validations to SoftwareRecord, be sure to
  # adjust the attributes here as well.
  include Devise::Test::ControllerHelpers
  render_views

  before do
    owner = FactoryBot.create(:owner)
    sign_in_user(owner)

    VendorRecord.create!(
      title: 'Vendor 1',
      description: 'test vendor'
    )
    SoftwareType.create!(
      title: 'Web app',
      description: 'test software type'
    )
  end

  let(:valid_attributes) do
    {
      title: 'A Good Software',
      description: 'A Good description about the software',
      status: 'In Development',
      software_type_id: SoftwareType.first.id,
      vendor_record_id: VendorRecord.first.id,
      created_by: 'Test Owner',
      developers: %w[Tester Random],
      tech_leads: ['Lead 1'],
      product_owners: %w[Owner1 Owner2]
    }
  end

  let(:invalid_attributes) do
    {
      title: '',
      description: '',
      status: '',
      software_type_id: '',
      vendor_record_id: ''
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SoftwareRecordsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  def sign_in_user(owner)
    sign_in owner
  end

  describe 'GET #index' do
    it 'returns a success response' do
      SoftwareRecord.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it 'has the correct content' do
      SoftwareRecord.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response.body).to match('\b(A.Good.Software)\b')
      expect(response.body).to_not have_content('In Development')
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      software_record = SoftwareRecord.create! valid_attributes
      get :show, params: { id: software_record.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response.body).to have_content('A Good Software')
      expect(response.body).to have_content('In Development')
      expect(response.body).not_to have_content('Test Owner')
      expect(response.body).to have_content('Tester')
      expect(response.body).to have_content('Random')
      expect(response.body).to have_content('Lead 1')
      expect(response.body).to have_content('Owner1')
      expect(response.body).to have_content('Owner2')
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to_not be_successful
      expect(response).to_not render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      software_record = SoftwareRecord.create! valid_attributes
      get :edit, params: { id: software_record.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new SoftwareRecord' do
        expect do
          post :create, params: { software_record: valid_attributes }, session: valid_session
        end.to change(SoftwareRecord, :count).by(1)
      end

      it 'redirects to the created software_record' do
        post :create, params: { software_record: valid_attributes }, session: valid_session
        expect(response).to redirect_to(SoftwareRecord.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { software_record: invalid_attributes }, session: valid_session
        expect(response).to_not be_successful
        expect(response).to redirect_to('/request/new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { title: 'A Great Software v2.0', description: 'An Updated good description of the software', status: 'To be decomissioned' }
      end

      it 'updates the requested software_record' do
        software_record = SoftwareRecord.create! valid_attributes
        put :update, params: { id: software_record.to_param, software_record: new_attributes }, session: valid_session
        software_record.reload
        expect(software_record.title).to eq('A Great Software v2.0')
        expect(software_record.description).to eq('An Updated good description of the software')
        expect(software_record.status).to eq('To be decomissioned')
        expect(software_record.created_by).to eq('Test Owner')
        expect(software_record.developers).to eq(%w[Tester Random])
        expect(software_record.tech_leads).to eq(['Lead 1'])
        expect(software_record.product_owners).to eq(%w[Owner1 Owner2])
      end

      it 'redirects to the software_record' do
        software_record = SoftwareRecord.create! valid_attributes
        put :update, params: { id: software_record.to_param, software_record: valid_attributes }, session: valid_session
        expect(response).to redirect_to(software_record)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        software_record = SoftwareRecord.create! valid_attributes
        put :update, params: { id: software_record.to_param, software_record: invalid_attributes }, session: valid_session
        expect(response).to be_successful
        expect(response).to render_template(:edit)
        expect(response.body).to have_content("Title can\\'t be blank")
        expect(response.body).to have_content("Description can\\'t be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested software_record' do
      software_record = SoftwareRecord.create! valid_attributes
      expect do
        delete :destroy, params: { id: software_record.to_param }, session: valid_session
      end.to change(SoftwareRecord, :count).by(0)
    end

    it 'redirects to the software_records list' do
      software_record = SoftwareRecord.create! valid_attributes
      delete :destroy, params: { id: software_record.to_param }, session: valid_session
      expect(response).to_not redirect_to(software_records_url)
    end
  end
end
