# frozen_string_literal: true

require 'logger'

# Test-only helpers for dartsass, esbuild, and Propshaft precompile.
#
# suppress_output reopens stdout/stderr file descriptors so shell-outs (yarn, esbuild)
# and Propshaft's rake logger stay quiet; assigning $stdout alone does not affect system().
module QuietTestBuilds
  PRECOMPILE_TASKS = %w[dartsass:build assets:precompile].freeze
  JAVASCRIPT_BUILD_TASKS = %w[javascript:prepare_node_path javascript:install javascript:build].freeze

  module_function

  def suppress_output
    node_options = ENV['NODE_OPTIONS']
    ENV['NODE_OPTIONS'] = [node_options, '--no-deprecation'].compact.join(' ')

    stdout = $stdout.dup
    stderr = $stderr.dup
    sink = File.open(File::NULL, 'w')
    $stdout.reopen(sink)
    $stderr.reopen(sink)
    yield
  ensure
    $stdout.reopen(stdout)
    $stderr.reopen(stderr)
    stdout.close
    stderr.close
    sink&.close
    if node_options.nil?
      ENV.delete('NODE_OPTIONS')
    else
      ENV['NODE_OPTIONS'] = node_options
    end
  end

  def invoke_dartsass_build!(app = Rails.application)
    app.load_tasks
    Rake::Task['dartsass:build'].reenable
    Rake::Task['dartsass:build'].invoke
  end

  def invoke_javascript_build!(app = Rails.application)
    app.load_tasks
    JAVASCRIPT_BUILD_TASKS.each { |name| Rake::Task[name].reenable }
    suppress_output { Rake::Task['javascript:build'].invoke }
  end

  def precompile_assets!(app = Rails.application)
    app.load_tasks
    PRECOMPILE_TASKS.each { |name| Rake::Task[name].reenable }
    suppress_output { Rake::Task['assets:precompile'].invoke }
  end
end
