# frozen_string_literal: true

require 'cgi'

module Users
  class SessionsController < Devise::SessionsController
    before_action :redirect_to_shibboleth, only: %i[new create]

    private

    def redirect_to_shibboleth
      return unless Rails.configuration.x.auth.shibboleth_enabled

      target_path = "#{request.script_name}/auth/shibboleth"
      redirect_to "/Shibboleth.sso/Login?target=#{CGI.escape(target_path)}&forceAuthn=1",
                  alert: 'Please sign in using University SSO.'
    end
  end
end
