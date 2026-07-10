# frozen_string_literal: true

# application.js is loaded with type="module" defer. Capybara's visit returns after
# DOMContentLoaded, before the esbuild bundle assigns window.Turbo — especially on CI.
module TurboHelpers
  def wait_for_turbo
    timeout = Capybara.default_max_wait_time
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    until turbo_loaded?
      raise "Turbo did not load within #{timeout}s (is app/assets/builds/application.js present?)" if Process.clock_gettime(Process::CLOCK_MONOTONIC) - start > timeout

      sleep 0.05
    end
  end

  def turbo_loaded?
    page.evaluate_script('typeof Turbo !== "undefined" && typeof Turbo.visit === "function"')
  end
end

RSpec.configure do |config|
  config.include TurboHelpers, type: :feature
end
