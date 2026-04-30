# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    allow(Rails.configuration.x.auth).to receive(:shibboleth_enabled).and_return(shibboleth_enabled)
  end

  describe 'GET #new' do
    context 'when shibboleth mode is enabled' do
      let(:shibboleth_enabled) { true }

      it 'redirects users to shibboleth login' do
        get :new

        expect(response).to redirect_to(shibboleth_login_path)
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
end
