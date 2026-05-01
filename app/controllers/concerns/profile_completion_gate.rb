# frozen_string_literal: true

module ProfileCompletionGate
  extend ActiveSupport::Concern

  included do
    before_action :require_profile_completion
  end

  protected

  def require_profile_completion
    return if skip_profile_completion_check?

    if profile_complete?
      session.delete(:require_profile_completion)
      return
    end

    # Prompt newly provisioned users once, but do not block dashboard access afterward.
    session.delete(:require_profile_completion)
    redirect_to user_edit_path(current_user.id, return_to: dashboard_path),
                alert: 'Please confirm your profile details before continuing.'
  end

  def skip_profile_completion_check?
    !user_signed_in? ||
      !Rails.configuration.x.auth.shibboleth_enabled ||
      current_user.role.to_s == 'root_admin' ||
      !session[:require_profile_completion] ||
      on_allowed_profile_page? ||
      devise_controller?
  end

  def profile_complete?
    current_user.department.present? && current_user.title.present?
  end

  def on_allowed_profile_page?
    controller_name == 'users' && %w[edit update].include?(action_name)
  end
end
