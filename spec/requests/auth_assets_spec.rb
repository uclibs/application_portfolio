# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication pages and assets', type: :request do
  describe 'local email sign-in' do
    around do |example|
      original_shibboleth = Rails.configuration.x.auth.shibboleth_enabled
      original_email = Rails.configuration.x.auth.allow_email_sign_in

      Rails.configuration.x.auth.shibboleth_enabled = false
      Rails.configuration.x.auth.allow_email_sign_in = true

      example.run
    ensure
      Rails.configuration.x.auth.shibboleth_enabled = original_shibboleth
      Rails.configuration.x.auth.allow_email_sign_in = original_email
    end

    it 'loads Propshaft application assets on the sign-in page' do
      get new_user_session_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to match(%r{application[.-][a-f0-9]+\.css|/assets/application\.css})
      expect(response.body).to match(%r{application[.-][a-f0-9]+\.js|/assets/application\.js})
      expect(response.body).to include('type="module"')
    end
  end

  describe 'Shibboleth mode' do
    around do |example|
      original_shibboleth = Rails.configuration.x.auth.shibboleth_enabled
      Rails.configuration.x.auth.shibboleth_enabled = true

      example.run
    ensure
      Rails.configuration.x.auth.shibboleth_enabled = original_shibboleth
    end

    it 'redirects sign-in to Shibboleth without rendering local login assets' do
      get new_user_session_path

      expect(response).to redirect_to('/Shibboleth.sso/Login?target=%2Fauth%2Fshibboleth&forceAuthn=1')
    end
  end
end
