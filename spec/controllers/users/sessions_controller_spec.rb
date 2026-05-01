# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    allow(Rails.configuration.x.auth).to receive(:shibboleth_enabled).and_return(shibboleth_enabled)
    allow(Rails.configuration.x.auth).to receive(:allow_email_sign_in).and_return(allow_email_sign_in)
  end

  let(:allow_email_sign_in) { true }

  describe 'GET #new' do
    context 'when shibboleth mode is enabled' do
      let(:shibboleth_enabled) { true }

      it 'redirects users to shibboleth login' do
        get :new

        expect(response).to redirect_to('/Shibboleth.sso/Login?target=%2Fauth%2Fshibboleth&forceAuthn=1')
      end
    end

    context 'when shibboleth mode is disabled' do
      let(:shibboleth_enabled) { false }

      it 'renders local login form' do
        get :new

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    context 'when shibboleth mode is enabled' do
      let(:shibboleth_enabled) { true }

      it 'redirects to Shibboleth without treating the request as local email sign-in' do
        user = FactoryBot.create(:viewer)

        post :create, params: { user: { email: user.email } }

        expect(response).to redirect_to('/Shibboleth.sso/Login?target=%2Fauth%2Fshibboleth&forceAuthn=1')
        expect(controller.current_user).to be_nil
      end
    end

    context 'when shibboleth mode is disabled' do
      let(:shibboleth_enabled) { false }

      context 'when local email sign-in is allowed' do
        let(:allow_email_sign_in) { true }

        it 'signs in an existing user by email (no password)' do
          user = FactoryBot.create(:viewer)

          post :create, params: { user: { email: user.email } }

          expect(response).to redirect_to(dashboard_path)
          expect(controller.current_user).to eq(user)
        end

        it 'redirects when the email is unknown' do
          post :create, params: { user: { email: 'nobody@example.com' } }

          expect(response).to redirect_to(new_user_session_path)
          expect(flash[:alert]).to eq('User email was not found.')
        end
      end

      context 'when local email sign-in is disabled' do
        let(:allow_email_sign_in) { false }

        it 'does not sign in and explains that local email sign-in is off' do
          user = FactoryBot.create(:viewer)

          post :create, params: { user: { email: user.email } }

          expect(response).to redirect_to(new_user_session_path)
          expect(flash[:alert]).to eq('Local email sign-in is disabled in this environment.')
          expect(controller.current_user).to be_nil
        end
      end
    end
  end
end
