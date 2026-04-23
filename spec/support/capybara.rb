# frozen_string_literal: true

require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.server = :puma, { Silent: true }

Capybara.register_driver :ci_selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless=new')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1400,1400')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = if ENV['CI']
                               :ci_selenium_chrome_headless
                             else
                               :selenium_chrome_headless
                             end
