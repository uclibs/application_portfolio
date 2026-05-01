# frozen_string_literal: true

class ShibbolethSessionsController < ApplicationController
  def create
    unless Rails.configuration.x.auth.shibboleth_enabled
      redirect_to new_user_session_path, alert: 'Shibboleth sign-in is not enabled in this environment.'
      return
    end

    attributes = identity_attributes
    normalized_first_name = User.normalized_name(attributes[:first_name], User::BLANK_FIRST_NAME)
    normalized_last_name = User.normalized_name(attributes[:last_name], User::BLANK_LAST_NAME)
    normalized_eppn = User.normalized_eppn(attributes[:eppn], normalized_first_name, normalized_last_name)
    user_existed = User.exists?(eppn: normalized_eppn)
    user = User.find_or_create_for_shibboleth!(attributes)
    session[:require_profile_completion] = true unless user_existed
    sign_in(:user, user)
    redirect_to after_sign_in_path_for(user)
  rescue User::ShibbolethIdentityError => e
    redirect_to root_path, alert: e.message
  rescue ActiveRecord::RecordInvalid => e
    @error_message = e.record.errors.full_messages.to_sentence
    render :error, status: :unprocessable_entity
  end

  private

  def identity_attributes
    {
      eppn: shib_value('eppn'),
      email: shib_value('mail'),
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
