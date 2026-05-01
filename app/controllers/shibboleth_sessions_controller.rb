# frozen_string_literal: true

class ShibbolethSessionsController < ApplicationController
  def create
    unless Rails.configuration.x.auth.shibboleth_enabled
      redirect_to new_user_session_path, alert: 'Shibboleth sign-in is not enabled in this environment.'
      return
    end

    identity_resolver = ShibbolethIdentityResolver.new(env: request.env)
    normalized_identity = identity_resolver.normalized_identity
    user_existed = User.exists?(eppn: normalized_identity[:eppn])
    user = ShibbolethUserProvisioner.find_or_create!(normalized_identity)
    session[:require_profile_completion] = true unless user_existed
    sign_in(:user, user)
    redirect_to after_sign_in_path_for(user)
  rescue ShibbolethUserProvisioner::IdentityError => e
    redirect_to root_path, alert: e.message
  rescue ActiveRecord::RecordInvalid => e
    @error_message = e.record.errors.full_messages.to_sentence
    render :error, status: :unprocessable_entity
  end
end
