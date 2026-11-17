# frozen_string_literal: true

require 'rails_helper'

module ChromeDriverResetHelpers
  def chrome_driver
    driver = Class.new do
      attr_reader :ancestor_reset_called

      def reset!
        @ancestor_reset_called = true
      end

      # ChromeDriver.extended asks the driver for a bridge and an options hash.
      def bridge
        browser_bridge = Object.new
        browser_bridge.define_singleton_method(:log) { nil }
        browser_bridge.define_singleton_method(:commands) { |_name| true }
        browser_bridge
      end

      def options
        { native_displayed: true }
      end
    end.new
    driver.extend(Capybara::Selenium::Driver::ChromeDriver)
    driver.instance_variable_set(:@browser, Object.new)
    driver
  end

  def record_cdp(driver, reject_wildcard: false)
    calls = []
    driver.define_singleton_method(:storage_types_to_clear) { 'cookies,local_storage' }
    driver.define_singleton_method(:execute_cdp) do |cmd, params = {}|
      calls << [cmd, params]
      return unless reject_wildcard && params[:origin] == '*'

      raise Selenium::WebDriver::Error::InvalidArgumentError, 'invalid argument: * is not a valid URL'
    end
    calls
  end

  def stub_navigation(driver)
    navigations = []
    browser = driver.instance_variable_get(:@browser)
    browser.define_singleton_method(:navigate) do
      target = Object.new
      target.define_singleton_method(:to) { |url| navigations << url }
      target
    end
    navigations
  end
end

RSpec.describe 'Chrome driver reset' do
  include ChromeDriverResetHelpers
  describe '#page_origin' do
    it 'keeps a non-default port' do
      driver = chrome_driver
      driver.define_singleton_method(:current_url) { 'http://127.0.0.1:3000/dashboard?q=1' }

      expect(driver.send(:page_origin)).to eq('http://127.0.0.1:3000')
    end

    it 'drops the default port' do
      driver = chrome_driver
      driver.define_singleton_method(:current_url) { 'https://example.com/path' }

      expect(driver.send(:page_origin)).to eq('https://example.com')
    end

    it 'ignores non-http pages' do
      driver = chrome_driver
      driver.define_singleton_method(:current_url) { 'about:blank' }

      expect(driver.send(:page_origin)).to be_nil
    end

    it 'returns nil when an alert blocks the current url' do
      driver = chrome_driver
      driver.define_singleton_method(:current_url) do
        raise Selenium::WebDriver::Error::UnexpectedAlertOpenError, 'alert'
      end

      expect(driver.send(:page_origin)).to be_nil
    end

    it 'returns nil for an unparseable url' do
      driver = chrome_driver
      driver.define_singleton_method(:current_url) { 'http://[' }

      expect(driver.send(:page_origin)).to be_nil
    end
  end

  describe '#clear_site_data' do
    it 'keeps the wildcard clear when Chrome accepts it' do
      driver = chrome_driver
      calls = record_cdp(driver)

      driver.send(:clear_site_data, 'http://127.0.0.1:3000')

      expect(calls).to eq([
                            ['Storage.clearDataForOrigin', { origin: '*', storageTypes: 'cookies,local_storage' }]
                          ])
    end

    it 'clears profile cookies and the page origin when Chrome rejects the wildcard' do
      driver = chrome_driver
      calls = record_cdp(driver, reject_wildcard: true)

      driver.send(:clear_site_data, 'http://127.0.0.1:3000')

      expect(calls).to eq([
                            ['Storage.clearDataForOrigin', { origin: '*', storageTypes: 'cookies,local_storage' }],
                            ['Network.clearBrowserCookies', {}],
                            ['Storage.clearDataForOrigin',
                             { origin: 'http://127.0.0.1:3000', storageTypes: 'cookies,local_storage' }]
                          ])
    end

    it 'clears only profile cookies when the example was not on an http page' do
      driver = chrome_driver
      calls = record_cdp(driver, reject_wildcard: true)

      driver.send(:clear_site_data, nil)

      expect(calls).to eq([
                            ['Storage.clearDataForOrigin', { origin: '*', storageTypes: 'cookies,local_storage' }],
                            ['Network.clearBrowserCookies', {}]
                          ])
    end

    it 'reraises other invalid-argument errors' do
      driver = chrome_driver
      driver.define_singleton_method(:execute_cdp) do |_cmd, _params = {}|
        raise Selenium::WebDriver::Error::InvalidArgumentError, 'something else'
      end

      expect { driver.send(:clear_site_data, 'http://127.0.0.1:3000') }
        .to raise_error(Selenium::WebDriver::Error::InvalidArgumentError, 'something else')
    end
  end

  describe '#reset!' do
    it 'does nothing before the browser starts' do
      driver = chrome_driver
      driver.instance_variable_set(:@browser, nil)

      expect(driver.reset!).to be_nil
    end

    it 'uses the stock reset for old chromedriver' do
      driver = chrome_driver
      driver.define_singleton_method(:page_origin) { 'http://127.0.0.1:3000' }
      driver.define_singleton_method(:window_handles) { ['main'] }
      driver.define_singleton_method(:switch_to_window) { |_handle| }
      driver.define_singleton_method(:chromedriver_version) { 72 }

      driver.reset!

      expect(driver.ancestor_reset_called).to be(true)
    end

    it 'closes extra windows, leaves storage alone when the clear is uniform, and resets site data' do
      driver = chrome_driver
      closed = []
      switched = []
      calls = record_cdp(driver, reject_wildcard: true)
      driver.define_singleton_method(:current_url) { 'http://127.0.0.1:3000/dashboard' }
      driver.define_singleton_method(:window_handles) { %w[main extra] }
      driver.define_singleton_method(:switch_to_window) { |handle| switched << handle }
      driver.define_singleton_method(:close_window) { |handle| closed << handle }
      driver.define_singleton_method(:chromedriver_version) { 120 }
      driver.define_singleton_method(:uniform_storage_clear?) { true }
      driver.define_singleton_method(:clear_storage) { raise 'storage should stay until the origin clear' }
      navigations = stub_navigation(driver)
      driver.define_singleton_method(:wait_for_empty_page) { |_timer| }

      driver.reset!

      expect(switched).to eq(['main'])
      expect(closed).to eq(['extra'])
      expect(navigations).to eq(['about:blank'])
      expect(calls.map(&:first)).to eq(
        ['Storage.clearDataForOrigin', 'Network.clearBrowserCookies', 'Storage.clearDataForOrigin']
      )
    end

    it 'clears page storage before navigating when storage clears are not uniform' do
      driver = chrome_driver
      cleared = false
      driver.define_singleton_method(:current_url) { 'about:blank' }
      driver.define_singleton_method(:window_handles) { ['main'] }
      driver.define_singleton_method(:switch_to_window) { |_handle| }
      driver.define_singleton_method(:chromedriver_version) { 120 }
      driver.define_singleton_method(:uniform_storage_clear?) { false }
      driver.define_singleton_method(:clear_storage) { cleared = true }
      stub_navigation(driver)
      driver.define_singleton_method(:wait_for_empty_page) { |_timer| }
      record_cdp(driver)

      driver.reset!

      expect(cleared).to be(true)
    end

    it 'accepts an unload alert and retries the reset' do
      driver = chrome_driver
      attempts = 0
      accepted = false
      driver.define_singleton_method(:current_url) { 'http://127.0.0.1:3000/' }
      driver.define_singleton_method(:window_handles) { ['main'] }
      driver.define_singleton_method(:switch_to_window) { |_handle| }
      driver.define_singleton_method(:chromedriver_version) { 120 }
      driver.define_singleton_method(:uniform_storage_clear?) { true }
      driver.define_singleton_method(:unhandled_alert_errors) do
        [::Selenium::WebDriver::Error::UnexpectedAlertOpenError]
      end
      stub_navigation(driver)
      driver.define_singleton_method(:wait_for_empty_page) do |_timer|
        attempts += 1
        raise Selenium::WebDriver::Error::UnexpectedAlertOpenError, 'alert' if attempts == 1
      end
      driver.define_singleton_method(:accept_unhandled_reset_alert) { accepted = true }
      record_cdp(driver)

      driver.reset!

      expect(accepted).to be(true)
      expect(attempts).to eq(2)
    end
  end
end
