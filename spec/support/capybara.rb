# frozen_string_literal: true

require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.server = :puma, { Silent: true }

Capybara.register_driver :ci_selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  # Pin browser and driver from browser-actions/setup-chrome so both come from the
  # same version (runner system chromedriver is often stale vs setup-chrome).
  chrome_bin = ENV.fetch('CHROME_BIN', nil)
  options.binary = chrome_bin if chrome_bin && File.exist?(chrome_bin)

  options.add_argument('--headless=new')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1400,1400')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')

  http_client = Selenium::WebDriver::Remote::Http::Default.new
  http_client.read_timeout = 180
  http_client.open_timeout = 180

  driver_args = { browser: :chrome, options: options, http_client: http_client }
  chromedriver_path = ENV.fetch('CHROMEDRIVER_PATH', nil)
  driver_args[:service] = Selenium::WebDriver::Service.chrome(path: chromedriver_path) if chromedriver_path && File.exist?(chromedriver_path)

  Capybara::Selenium::Driver.new(app, **driver_args)
end

# Chrome 158+ rejects Storage.clearDataForOrigin with origin "*" (* is not a valid URL).
# Capybara 3.40 still sends that wildcard while resetting the browser, so every
# JavaScript example fails in after-hook cleanup on current CI Chrome.
# The wildcard used to mean "every origin". When Chrome refuses it, clear cookies
# for the whole profile and storage for the page the example was on.
module Capybara
  module Selenium
    class Driver
      module ChromeDriver
        def reset!
          return unless @browser

          origin = page_origin
          switch_to_window(window_handles.first)
          window_handles.slice(1..).each { |win| close_window(win) }
          return super if chromedriver_version < 73

          timer = Capybara::Helpers.timer(expire_in: 10)
          begin
            clear_storage unless uniform_storage_clear?
            @browser.navigate.to('about:blank')
            wait_for_empty_page(timer)
          rescue *unhandled_alert_errors
            accept_unhandled_reset_alert
            retry
          end

          clear_site_data(origin)
        end

        private

        def page_origin
          uri = URI.parse(current_url.to_s)
          return unless uri.is_a?(URI::HTTP) && uri.host

          port = ":#{uri.port}" unless uri.port == uri.default_port
          "#{uri.scheme}://#{uri.host}#{port}"
        rescue URI::InvalidURIError, ::Selenium::WebDriver::Error::UnexpectedAlertOpenError
          nil
        end

        def clear_site_data(origin)
          execute_cdp('Storage.clearDataForOrigin', origin: '*', storageTypes: storage_types_to_clear)
        rescue ::Selenium::WebDriver::Error::InvalidArgumentError => e
          raise unless e.message.include?('is not a valid URL')

          execute_cdp('Network.clearBrowserCookies')
          return if origin.nil?

          execute_cdp('Storage.clearDataForOrigin', origin: origin, storageTypes: storage_types_to_clear)
        end
      end
    end
  end
end

Capybara.javascript_driver = if ENV['CI']
                               :ci_selenium_chrome_headless
                             else
                               :selenium_chrome_headless
                             end
