# frozen_string_literal: true

RSpec.configure do |config|
  # Esbuild build specs shell out to yarn; skip locally for quieter runs, keep in CI.
  config.filter_run_excluding :build unless ENV['CI']
end
