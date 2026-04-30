# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShibbolethSessionsController, type: :controller do
  describe 'GET #create' do
    before do
      allow(Rails.configuration.x.auth).to receive(:shibboleth_enabled).and_return(shibboleth_enabled)
    end

    context 'when shibboleth is disabled' do
      let(:shibboleth_enabled) { false }

      it 'redirects to local sign in' do
        get :create

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when shibboleth is enabled' do
      let(:shibboleth_enabled) { true }

      before do
        request.env['HTTP_MAIL'] = 'admin@ucmail.uc.edu'
        request.env['HTTP_GIVENNAME'] = 'Existing'
        request.env['HTTP_SN'] = 'Admin'
      end

      it 'signs in an existing user without changing their role' do
        existing_user = FactoryBot.create(:admin, email: 'admin@ucmail.uc.edu')

        get :create

        expect(controller.current_user).to eq(existing_user)
        expect(existing_user.reload.role.to_s).to eq('root_admin')
      end

      it 'creates a new viewer user for a first-time login' do
        allow_any_instance_of(User).to receive(:send_admin_mail).and_return(true)

        expect do
          get :create
        end.to change(User, :count).by(1)

        created_user = User.find_by(email: 'admin@ucmail.uc.edu')
        expect(created_user.role.to_s).to eq('viewer')
        expect(created_user.active).to be(true)
      end

      it 'rejects login when required attributes are missing' do
        request.env['HTTP_GIVENNAME'] = nil

        get :create

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to include('missing required name')
      end
    end
  end
end
