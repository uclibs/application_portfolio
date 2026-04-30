# frozen_string_literal: true

class ShibbolethSessionsController < ApplicationController
  def create
    unless Rails.configuration.x.auth.shibboleth_enabled
      redirect_to new_user_session_path, alert: 'Shibboleth sign-in is not enabled in this environment.'
      return
    end

    user = User.find_or_create_for_shibboleth!(identity_attributes)
    sign_in(:user, user)
    redirect_to after_sign_in_path_for(user)
  rescue User::ShibbolethIdentityError => e
    redirect_to root_path, alert: e.message
  end

  private

  def identity_attributes
    {
      email: shib_value('mail') || shib_value('eppn'),
      first_name: shib_value('givenName'),
      last_name: shib_value('sn')
    }
  end

  def shib_value(attribute_name)
    values = [
      request.env["HTTP_#{attribute_name.upcase.tr('-', '_')}"],
      request.env[attribute_name],
      request.headers[attribute_name]
    ]
    values.compact.find(&:present?)&.strip
  end
end
