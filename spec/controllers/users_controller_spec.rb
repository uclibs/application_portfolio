# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views
  before do
    admin = FactoryBot.create(:admin)
    sign_in_user(admin)
  end

  def sign_in_user(admin)
    sign_in admin
  end

  let(:valid_attributes) do
    {
      first_name: 'Admin',
      last_name: 'Test',
      email: 'admin13@uc.edu',
      password: 'admintest123',
      password_confirmation: 'admintest123',
      roles: 'admin'
    }
  end

  let(:new_attributes) do
    {
      first_name: 'Admin 2',
      last_name: 'Test 2',
      email: 'admin13@uc.edu',
      password: 'admintest123',
      password_confirmation: 'admintest123',
      roles: 'user'
    }
  end

  let(:valid_session) { {} }

  describe 'GET #edit' do
    it 'returns http success' do
      user = User.create! valid_attributes
      get :edit, params: { id: user.to_param }, session: valid_session
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      user = User.create! valid_attributes
      get :show, params: { id: user.to_param }, session: valid_session
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #index' do
    it 'returns a success response' do
      User.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it 'has the correct content' do
      User.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response.body).to match('\b(Admin)\b')
    end
  end

  describe 'POST #update' do
    it 'updates the user' do
      new_user = User.create! new_attributes
      post :update, params: { id: User.second.id, first_name: new_attributes[:first_name], last_name: new_attributes[:last_name],
                              email: new_attributes[:email], password: new_attributes[:password], password_confirmation: new_attributes[:password_confirmation], roles: new_attributes[:roles] }, session: valid_session
      new_user.reload
      expect(new_user.first_name).to eq('Admin 2')
      expect(new_user.last_name).to eq('Test 2')
      expect(new_user.email).to eq('admin13@uc.edu')
      expect(new_user.roles).to eq([:user])
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      user = User.create! valid_attributes
      expect do
        delete :destroy, params: { id: user.to_param }, session: valid_session
      end.to change(User, :count).by(-1)
    end
  end

  describe 'GET #user_status' do
    it 'redirects to the user page when de-activated' do
      user = User.create! valid_attributes
      user.active = true
      get :user_status, params: { id: user.to_param }, session: valid_session
      expect(response).to redirect_to(users_show_path(user.id))
    end

    it 'redirects to the user profile when activated' do
      user = User.create! valid_attributes
      user.active = false
      get :user_status, params: { id: user.to_param }, session: valid_session
      expect(response).to redirect_to(users_show_path(user.id))
    end
  end
end
