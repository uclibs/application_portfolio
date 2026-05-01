# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShibbolethSessionsController, type: :controller do
  render_views

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
        expect(session[:require_profile_completion]).to be_nil
      end

      it 'creates a new viewer user for a first-time login' do
        allow_any_instance_of(User).to receive(:send_admin_mail).and_return(true)

        expect do
          get :create
        end.to change(User, :count).by(1)

        created_user = User.find_by(email: 'admin@ucmail.uc.edu')
        expect(created_user.role.to_s).to eq('viewer')
        expect(created_user.active).to be(true)
        expect(session[:require_profile_completion]).to eq(true)
      end

      it 'creates a user with fallback names when identity names are missing' do
        allow_any_instance_of(User).to receive(:send_admin_mail).and_return(true)
        request.env['HTTP_GIVENNAME'] = nil
        request.env['HTTP_SN'] = nil
        request.env['HTTP_MAIL'] = nil

        expect do
          get :create
        end.to change(User, :count).by(1)

        created_user = User.find_by(email: 'blankfirstname.blanklastname@uc.edu')
        expect(response).to redirect_to(dashboard_path)
        expect(created_user.first_name).to eq('BlankFirstName')
        expect(created_user.last_name).to eq('BlankLastName')
      end

      it 'renders a validation error page with the exact message' do
        invalid_user = User.new(email: 'manager@example.com', first_name: 'Manager', last_name: 'Example')
        invalid_user.errors.add(:base, 'Synthetic validation failure for troubleshooting')

        allow(User).to receive(:find_or_create_for_shibboleth!).and_raise(ActiveRecord::RecordInvalid.new(invalid_user))

        get :create

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:error)
        expect(response.body).to include('Synthetic validation failure for troubleshooting')
      end
    end
  end
end
