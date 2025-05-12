# config/initializers/uc_sso.rb

require 'uc_sso'
require 'uc_sso/controller_hooks'

UcSso.configure do |config|
  # Shibboleth UID field to match user by (typically "eppn")
  config.middleware_options[:uid_field] = 'eppn'

  # Mapping of info fields returned from Shibboleth
  config.middleware_options[:info_fields] = {
    email: 'mail',
    name: 'displayName'
  }

  Rails.logger.info ">> UcSso.methods: #{UcSso.methods}"

end

