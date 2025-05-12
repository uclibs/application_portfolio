# app/controllers/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include UcSso::ControllerHooks

  def shibboleth
    handle_uc_sso_callback
  end
end
