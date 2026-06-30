# frozen_string_literal: true

require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.server = :puma, { Silent: true }

Capybara.register_driver :ci_selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  # Pin the browser binary in CI (browser-actions/setup-chrome) so Selenium Manager
  # downloads a matching chromedriver instead of using the runner's system Chrome.
  chrome_bin = ENV.fetch('CHROME_BIN', nil)
  options.binary = chrome_bin if chrome_bin.present? && File.exist?(chrome_bin)

  options.add_argument('--headless=new')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1400,1400')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')

  driver_options = {
    app: app,
    browser: :chrome,
    options: options
  }

  chromedriver_path = ENV.fetch('CHROMEDRIVER_PATH', nil)
  driver_options[:service] = Selenium::WebDriver::Service.chrome(path: chromedriver_path) if chromedriver_path.present? && File.exist?(chromedriver_path)

  Capybara::Selenium::Driver.new(**driver_options)
end

Capybara.javascript_driver = if ENV['CI']
                               :ci_selenium_chrome_headless
                             else
                               :selenium_chrome_headless
                             end
