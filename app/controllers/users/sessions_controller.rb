# frozen_string_literal: true

require 'cgi'

module Users
  class SessionsController < Devise::SessionsController
    before_action :redirect_to_shibboleth, only: %i[new create]
    before_action :sign_in_with_email, only: :create

    private

    def redirect_to_shibboleth
      return unless Rails.configuration.x.auth.shibboleth_enabled

      target_path = "#{request.script_name}/auth/shibboleth"
      redirect_to "/Shibboleth.sso/Login?target=#{CGI.escape(target_path)}&forceAuthn=1",
                  alert: 'Please sign in using University SSO.'
    end

    def sign_in_with_email
      return if Rails.configuration.x.auth.shibboleth_enabled

      unless Rails.configuration.x.auth.allow_email_sign_in
        redirect_to new_user_session_path, alert: 'Local email sign-in is disabled in this environment.'
        return
      end

      user = User.find_by(email: params.dig(:user, :email).to_s.strip.downcase)
      if user.present?
        sign_in(:user, user)
        redirect_to after_sign_in_path_for(user)
      else
        redirect_to new_user_session_path, alert: 'User email was not found.'
      end
    end
  end
end
