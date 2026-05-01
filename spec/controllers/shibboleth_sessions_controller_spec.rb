# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShibbolethSessionsController, type: :controller do
  render_views

  describe 'GET #create' do
    before do
      allow(Rails.configuration.x.auth).to receive(:shibboleth_enabled).and_return(shibboleth_enabled)
      allow(Rails.configuration.x.auth).to receive(:allow_legacy_shibboleth_env_keys).and_return(false)
      allow(Rails.configuration.x.auth).to receive(:expose_shibboleth_validation_errors).and_return(true)
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
        request.env['HTTP_EPPN'] = 'admin@ucmail.uc.edu'
        request.env['HTTP_MAIL'] = 'admin@ucmail.uc.edu'
        request.env['HTTP_GIVENNAME'] = 'Existing'
        request.env['HTTP_SN'] = 'Admin'
      end

      it 'signs in an existing user without changing their role' do
        existing_user = FactoryBot.create(:admin, eppn: 'admin@ucmail.uc.edu', email: 'admin@ucmail.uc.edu')

        get :create

        expect(controller.current_user).to eq(existing_user)
        expect(existing_user.reload.role.to_s).to eq('root_admin')
        expect(session[:require_profile_completion]).to be_nil
      end

      it 'creates a new viewer user for a first-time login' do
        expect do
          get :create
        end.to change(User, :count).by(1)

        created_user = User.find_by(eppn: 'admin@ucmail.uc.edu')
        expect(created_user.role.to_s).to eq('viewer')
        expect(created_user.active).to be(true)
        expect(session[:require_profile_completion]).to eq(true)
      end

      it 'creates a user with fallback names when identity names are missing' do
        request.env['HTTP_GIVENNAME'] = nil
        request.env['HTTP_SN'] = nil
        request.env['HTTP_EPPN'] = nil
        request.env['HTTP_MAIL'] = nil

        expect do
          get :create
        end.to change(User, :count).by(1)

        created_user = User.find_by(eppn: 'blankfirstname.blanklastname@uc.edu')
        expect(response).to redirect_to(dashboard_path)
        expect(created_user.first_name).to eq('BlankFirstName')
        expect(created_user.last_name).to eq('BlankLastName')
        expect(created_user.email).to eq('blankfirstname.blanklastname@uc.edu')
      end

      it 'renders a validation error page with the exact message' do
        invalid_user = User.new(email: 'manager@example.com', first_name: 'Manager', last_name: 'Example')
        invalid_user.errors.add(:base, 'Synthetic validation failure for troubleshooting')

        allow(ShibbolethUserProvisioner).to receive(:find_or_create!).and_raise(ActiveRecord::RecordInvalid.new(invalid_user))

        get :create

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:error)
        expect(response.body).to include('Synthetic validation failure for troubleshooting')
      end

      it 'does not expose validation internals when troubleshooting details are disabled' do
        allow(Rails.configuration.x.auth).to receive(:expose_shibboleth_validation_errors).and_return(false)

        invalid_user = User.new(email: 'manager@example.com', first_name: 'Manager', last_name: 'Example')
        invalid_user.errors.add(:base, 'Synthetic validation failure for troubleshooting')

        allow(ShibbolethUserProvisioner).to receive(:find_or_create!).and_raise(ActiveRecord::RecordInvalid.new(invalid_user))

        get :create

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:error)
        expect(response.body).not_to include('Synthetic validation failure for troubleshooting')
        expect(response.body).to include("couldn't finish setting up")
      end

      it 'ignores unscoped env values in canonical-header mode' do
        request.env.delete('HTTP_EPPN')
        request.env.delete('HTTP_MAIL')
        request.env['eppn'] = 'spoofed-env@uc.edu'
        request.env['mail'] = 'spoofed-env@uc.edu'
        request.env['HTTP_GIVENNAME'] = nil
        request.env['HTTP_SN'] = nil

        get :create

        created_user = User.find_by(eppn: 'blankfirstname.blanklastname@uc.edu')
        expect(created_user).to be_present
        expect(created_user.email).to eq('blankfirstname.blanklastname@uc.edu')
      end

      it 'can accept REDIRECT_HTTP_* values when rollback flag is enabled' do
        allow(Rails.configuration.x.auth).to receive(:allow_legacy_shibboleth_env_keys).and_return(true)
        request.env.delete('HTTP_EPPN')
        request.env.delete('HTTP_MAIL')
        request.env.delete('HTTP_GIVENNAME')
        request.env.delete('HTTP_SN')
        request.env['REDIRECT_HTTP_EPPN'] = 'redirected@uc.edu'
        request.env['REDIRECT_HTTP_MAIL'] = 'redirected@uc.edu'
        request.env['REDIRECT_HTTP_GIVENNAME'] = 'Redirected'
        request.env['REDIRECT_HTTP_SN'] = 'User'

        get :create

        created_user = User.find_by(eppn: 'redirected@uc.edu')
        expect(created_user).to be_present
        expect(created_user.email).to eq('redirected@uc.edu')
      end
    end
  end
end
