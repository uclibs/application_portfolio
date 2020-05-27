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
      email: 'admin13@example.com',
      password: 'admintest123',
      password_confirmation: 'admintest123',
      roles: 'admin'
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
end
