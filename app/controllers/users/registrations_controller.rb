# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :attach_generated_password, only: :create

    private

    def attach_generated_password
      return unless sign_up_params[:password].blank?

      generated_password = Devise.friendly_token(32)
      params[resource_name][:password] = generated_password
      params[resource_name][:password_confirmation] = generated_password
    end
  end
end
