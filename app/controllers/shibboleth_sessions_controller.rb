# frozen_string_literal: true

class ShibbolethSessionsController < ApplicationController
  def create
    unless Rails.configuration.x.auth.shibboleth_enabled
      redirect_to new_user_session_path, alert: 'Shibboleth sign-in is not enabled in this environment.'
      return
    end

    attributes = ShibbolethAttributeReader.new(request.env).attributes
    normalized_identity = ShibbolethIdentityNormalizer.new(attributes).normalized
    user_existed = User.exists?(eppn: normalized_identity[:eppn])
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

end
