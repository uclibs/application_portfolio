# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Redirect to dashboard on user login
  def after_sign_in_path_for(_resource)
    # return the path based on resource
    dashboard_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name department title email password password_confirmation current_password roles active])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name department title email password password_confirmation current_password])
  end
end
