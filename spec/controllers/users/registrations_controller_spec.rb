# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  let(:user) { FactoryBot.create(:viewer, department: 'Libraries', title: 'Staff') }

  describe 'PUT #update' do
    it 'updates profile fields without requiring a password' do
      put :update, params: { user: { title: 'Analyst' } }

      expect(response).to have_http_status(:redirect)
      expect(user.reload.title).to eq('Analyst')
    end
  end
end
