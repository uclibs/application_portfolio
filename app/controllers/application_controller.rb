# frozen_string_literal: true

# Application Controller is the base controller
class ApplicationController < ActionController::Base
  # Redirect to dashboard on user login
  def after_sign_in_path_for(_resource)
    # return the path based on resource
    dashboard_path
  end
end
