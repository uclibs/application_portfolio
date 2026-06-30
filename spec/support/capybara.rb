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

Capybara.javascript_driver = if ENV['CI']
                               :ci_selenium_chrome_headless
                             else
                               :selenium_chrome_headless
                             end
