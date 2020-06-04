# frozen_string_literal: true

Recaptcha.configure do |config|
  config.site_key = ENV['APP_PORTFOLIO_reCAPTCHA_SITE_KEY']
  config.secret_key = ENV['APP_PORTFOLIO_reCAPTCHA_SECRET_KEY']
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end
