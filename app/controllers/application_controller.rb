# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::Base
  helper_method :navigation
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :require_profile_completion
  $deployed_at = Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')
  # Redirect to dashboard on user login
  def after_sign_in_path_for(_resource)
    # return the path based on resource
    dashboard_path
  end

  protected

  def require_profile_completion
    return if skip_profile_completion_check?

    redirect_to user_edit_path(current_user.id, return_to: dashboard_path),
                alert: 'Please confirm your profile details before continuing.'
  end

  def skip_profile_completion_check?
    !user_signed_in? ||
      !Rails.configuration.x.auth.shibboleth_enabled ||
      current_user.role.to_s == 'root_admin' ||
      profile_complete? ||
      on_allowed_profile_page? ||
      devise_controller?
  end

  def profile_complete?
    current_user.department.present? && current_user.title.present?
  end

  def on_allowed_profile_page?
    controller_name == 'users' && %w[edit update].include?(action_name)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[first_name last_name department title email roles active])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[first_name last_name department title email])
  end
end
