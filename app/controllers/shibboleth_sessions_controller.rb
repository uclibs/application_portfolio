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
    normalized_eppn = User.normalized_eppn(attributes[:eppn], attributes[:email], normalized_first_name, normalized_last_name)
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
    normalized = attribute_name.to_s.tr('-', '_')
    canonical_header_key = "HTTP_#{normalized.upcase}"
    trusted_keys = [
      canonical_header_key,
      "REDIRECT_#{canonical_header_key}",
      attribute_name.to_s,
      attribute_name.to_s.downcase,
      attribute_name.to_s.upcase
    ].uniq

    trusted_keys.each do |key|
      value = request.env[key].to_s.strip
      return value if value.present?
    end

    nil
  end
end
