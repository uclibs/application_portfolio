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

# admin specs

RSpec.describe SoftwareTypesController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views
  # This should return the minimal set of attributes required to create a valid
  # SoftwareType. As you add validations to SoftwareType, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      title: 'Desktop',
      description: 'A desktop application'
    }
  end

  let(:invalid_attributes) do
    {
      title: '',
      description: ''
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # VendorRecordsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  def sign_in_user(admin)
    sign_in admin
  end

  before do
    admin = FactoryBot.create(:admin)
    sign_in_user(admin)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      SoftwareType.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it 'has the correct content' do
      SoftwareType.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response.body).to have_content('Desktop')
      expect(response.body).to_not have_content('A desktop application')
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      software_type = SoftwareType.create! valid_attributes
      get :show, params: { id: software_type.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response.body).to have_content('Desktop')
      expect(response.body).to have_content('A desktop application')
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
      software_type = SoftwareType.create! valid_attributes
      get :edit, params: { id: software_type.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new SoftwareType' do
        expect do
          post :create, params: { software_type: valid_attributes }, session: valid_session
        end.to change(SoftwareType, :count).by(1)
      end

      it 'redirects to the created software_type' do
        post :create, params: { software_type: valid_attributes }, session: valid_session
        expect(response).to redirect_to(SoftwareType.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { software_type: invalid_attributes }, session: valid_session
        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { title: 'Web App', description: 'Web Application' }
      end

      it 'updates the requested software_type' do
        software_type = SoftwareType.create! valid_attributes
        put :update, params: { id: software_type.to_param, software_type: new_attributes },
                     session: valid_session
        software_type.reload
        expect(software_type.title).to eq('Web App')
        expect(software_type.description).to eq('Web Application')
      end

      it 'redirects to the software_type' do
        software_type = SoftwareType.create! valid_attributes
        put :update, params: { id: software_type.to_param, software_type: valid_attributes },
                     session: valid_session
        expect(response).to redirect_to(software_type)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        software_type = SoftwareType.create! valid_attributes
        put :update, params: { id: software_type.to_param, software_type: invalid_attributes },
                     session: valid_session
        expect(response).to be_successful
        expect(response).to render_template(:edit)
        expect(response.body).to have_content("Title can\\'t be blank")
        expect(response.body).to have_content("Description can\\'t be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested software_type' do
      software_type = SoftwareType.create! valid_attributes
      expect do
        delete :destroy, params: { id: software_type.to_param }, session: valid_session
      end.to change(SoftwareType, :count).by(-1)
    end

    it 'redirects to the software_types list' do
      session[:previous] = software_types_url
      software_type = SoftwareType.create! valid_attributes
      delete :destroy, params: { id: software_type.to_param }, session: valid_session
      expect(response).to redirect_to(session[:previous])
    end
  end
end

# manager specs

RSpec.describe SoftwareTypesController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views
  # This should return the minimal set of attributes required to create a valid
  # SoftwareType. As you add validations to SoftwareType, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      title: 'Desktop',
      description: 'A desktop application'
    }
  end

  let(:invalid_attributes) do
    {
      title: '',
      description: ''
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # VendorRecordsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  def sign_in_user(manager)
    sign_in manager
  end

  before do
    manager = FactoryBot.create(:manager)
    sign_in_user(manager)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      SoftwareType.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it 'has the correct content' do
      SoftwareType.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response.body).to have_content('Desktop')
      expect(response.body).to_not have_content('A desktop application')
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      software_type = SoftwareType.create! valid_attributes
      get :show, params: { id: software_type.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response.body).to have_content('Desktop')
      expect(response.body).to have_content('A desktop application')
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
      software_type = SoftwareType.create! valid_attributes
      get :edit, params: { id: software_type.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new SoftwareType' do
        expect do
          post :create, params: { software_type: valid_attributes }, session: valid_session
        end.to change(SoftwareType, :count).by(1)
      end

      it 'redirects to the created software_type' do
        post :create, params: { software_type: valid_attributes }, session: valid_session
        expect(response).to redirect_to(SoftwareType.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { software_type: invalid_attributes }, session: valid_session
        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { title: 'Web App', description: 'Web Application' }
      end

      it 'updates the requested software_type' do
        software_type = SoftwareType.create! valid_attributes
        put :update, params: { id: software_type.to_param, software_type: new_attributes },
                     session: valid_session
        software_type.reload
        expect(software_type.title).to eq('Web App')
        expect(software_type.description).to eq('Web Application')
      end

      it 'redirects to the software_type' do
        software_type = SoftwareType.create! valid_attributes
        put :update, params: { id: software_type.to_param, software_type: valid_attributes },
                     session: valid_session
        expect(response).to redirect_to(software_type)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        software_type = SoftwareType.create! valid_attributes
        put :update, params: { id: software_type.to_param, software_type: invalid_attributes },
                     session: valid_session
        expect(response).to be_successful
        expect(response).to render_template(:edit)
        expect(response.body).to have_content("Title can\\'t be blank")
        expect(response.body).to have_content("Description can\\'t be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested software_type' do
      software_type = SoftwareType.create! valid_attributes
      expect do
        delete :destroy, params: { id: software_type.to_param }, session: valid_session
      end.to change(SoftwareType, :count).by(-1)
    end

    it 'redirects to the software_types list' do
      session[:previous] = software_types_url
      software_type = SoftwareType.create! valid_attributes
      delete :destroy, params: { id: software_type.to_param }, session: valid_session
      expect(response).to redirect_to(session[:previous])
    end
  end
end

# owner specs

RSpec.describe SoftwareTypesController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views
  # This should return the minimal set of attributes required to create a valid
  # SoftwareType. As you add validations to SoftwareType, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      title: 'Desktop',
      description: 'A desktop application'
    }
  end

  let(:invalid_attributes) do
    {
      title: '',
      description: ''
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # VendorRecordsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  def sign_in_user(owner)
    sign_in owner
  end

  before do
    owner = FactoryBot.create(:owner)
    sign_in_user(owner)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      SoftwareType.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it 'has the correct content' do
      SoftwareType.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response.body).to have_content('Desktop')
      expect(response.body).to_not have_content('A desktop application')
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      software_type = SoftwareType.create! valid_attributes
      get :show, params: { id: software_type.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response.body).to have_content('Desktop')
      expect(response.body).to have_content('A desktop application')
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
      software_type = SoftwareType.create! valid_attributes
      get :edit, params: { id: software_type.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new SoftwareType' do
        expect do
          post :create, params: { software_type: valid_attributes }, session: valid_session
        end.to change(SoftwareType, :count).by(0)
      end

      it 'redirects to the created software_type' do
        post :create, params: { software_type: valid_attributes }, session: valid_session
        expect(response).to_not redirect_to(SoftwareType.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { software_type: invalid_attributes }, session: valid_session
        expect(response).to_not be_successful
        expect(response).to_not render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { title: 'Web App', description: 'Web Application' }
      end

      it 'updates the requested software_type' do
        software_type = SoftwareType.create! valid_attributes
        put :update, params: { id: software_type.to_param, software_type: new_attributes },
                     session: valid_session
        software_type.reload
        expect(software_type.title).to eq('Web App')
        expect(software_type.description).to eq('Web Application')
      end

      it 'redirects to the software_type' do
        software_type = SoftwareType.create! valid_attributes
        put :update, params: { id: software_type.to_param, software_type: valid_attributes },
                     session: valid_session
        expect(response).to redirect_to(software_type)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        software_type = SoftwareType.create! valid_attributes
        put :update, params: { id: software_type.to_param, software_type: invalid_attributes },
                     session: valid_session
        expect(response).to be_successful
        expect(response).to render_template(:edit)
        expect(response.body).to have_content("Title can\\'t be blank")
        expect(response.body).to have_content("Description can\\'t be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested software_type' do
      software_type = SoftwareType.create! valid_attributes
      expect do
        delete :destroy, params: { id: software_type.to_param }, session: valid_session
      end.to change(SoftwareType, :count).by(0)
    end

    it 'redirects to the software_types list' do
      session[:previous] = software_types_url
      software_type = SoftwareType.create! valid_attributes
      delete :destroy, params: { id: software_type.to_param }, session: valid_session
      expect(response).to_not redirect_to(session[:previous])
    end
  end
end

# viewer specs

RSpec.describe SoftwareTypesController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views
  # This should return the minimal set of attributes required to create a valid
  # SoftwareType. As you add validations to SoftwareType, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      title: 'Desktop',
      description: 'A desktop application'
    }
  end

  let(:invalid_attributes) do
    {
      title: '',
      description: ''
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # VendorRecordsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  def sign_in_user(viewer)
    sign_in viewer
  end

  before do
    viewer = FactoryBot.create(:viewer)
    sign_in_user(viewer)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      SoftwareType.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it 'has the correct content' do
      SoftwareType.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response.body).to have_content('Desktop')
      expect(response.body).to_not have_content('A desktop application')
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      software_type = SoftwareType.create! valid_attributes
      get :show, params: { id: software_type.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response.body).to have_content('Desktop')
      expect(response.body).to have_content('A desktop application')
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
      software_type = SoftwareType.create! valid_attributes
      get :edit, params: { id: software_type.to_param }, session: valid_session
      expect(response).to_not be_successful
      expect(response).to_not render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new SoftwareType' do
        expect do
          post :create, params: { software_type: valid_attributes }, session: valid_session
        end.to change(SoftwareType, :count).by(0)
      end

      it 'redirects to the created software_type' do
        post :create, params: { software_type: valid_attributes }, session: valid_session
        expect(response).to_not redirect_to(SoftwareType.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { software_type: invalid_attributes }, session: valid_session
        expect(response).to_not be_successful
        expect(response).to_not render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { title: 'Web App', description: 'Web Application' }
      end

      it 'updates the requested software_type' do
        software_type = SoftwareType.create! valid_attributes
        put :update, params: { id: software_type.to_param, software_type: new_attributes },
                     session: valid_session
        software_type.reload
        expect(software_type.title).to_not eq('Web App')
        expect(software_type.description).to_not eq('Web Application')
      end

      it 'redirects to the software_type' do
        software_type = SoftwareType.create! valid_attributes
        put :update, params: { id: software_type.to_param, software_type: valid_attributes },
                     session: valid_session
        expect(response).to_not redirect_to(software_type)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        software_type = SoftwareType.create! valid_attributes
        put :update, params: { id: software_type.to_param, software_type: invalid_attributes },
                     session: valid_session
        expect(response).to_not be_successful
        expect(response).to_not render_template(:edit)
        expect(response.body).to_not have_content("Title can\\'t be blank")
        expect(response.body).to_not have_content("Description can\\'t be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested software_type' do
      software_type = SoftwareType.create! valid_attributes
      expect do
        delete :destroy, params: { id: software_type.to_param }, session: valid_session
      end.to change(SoftwareType, :count).by(0)
    end

    it 'redirects to the software_types list' do
      session[:previous] = software_types_url
      software_type = SoftwareType.create! valid_attributes
      delete :destroy, params: { id: software_type.to_param }, session: valid_session
      expect(response).to_not redirect_to(session[:previous])
    end
  end
end
