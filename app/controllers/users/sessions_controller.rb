# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    before_action :redirect_to_shibboleth, only: %i[new create]

    private

    def redirect_to_shibboleth
      return unless Rails.configuration.x.auth.shibboleth_enabled

      redirect_to shibboleth_login_path, alert: 'Please sign in using University SSO.'
    end
  end
end
