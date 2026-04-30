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
    return unless user_signed_in?
    return unless Rails.configuration.x.auth.shibboleth_enabled
    return if current_user.role.to_s == 'root_admin'
    return if current_user.department.present? && current_user.title.present?
    return if controller_name == 'users' && %w[edit update].include?(action_name)
    return if devise_controller?

    redirect_to user_edit_path(current_user.id), alert: 'Please confirm your profile details before continuing.'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[first_name last_name department title email password password_confirmation
                                               current_password roles active])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[first_name last_name department title email password password_confirmation
                                               current_password])
  end
end
