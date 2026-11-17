# frozen_string_literal: true

require 'rails_helper'
require 'open3'

# javascript:install comes from jsbundling-rails and may or may not exist when this
# file loads. Each order runs in its own process so both sides of that guard are measured.
RSpec.describe 'javascript:prepare_node_path' do
  it 'applies the node environment and runs before javascript:install' do
    Rails.application.load_tasks
    task = Rake::Task['javascript:prepare_node_path']
    task.reenable
    allow(JavascriptBuildEnv).to receive(:apply!)

    task.invoke

    # load_tasks reloads lib/tasks on every call, so this action can be registered
    # more than once by the time the suite reaches this example.
    expect(JavascriptBuildEnv).to have_received(:apply!).at_least(:once)
    expect(Rake::Task['javascript:install'].prerequisites).to include('javascript:prepare_node_path')
  ensure
    task&.reenable
  end

  it 'leaves javascript:install alone when that task has not been defined' do
    stdout, stderr, status = load_rake_file(define_install: false)

    expect(status).to be_success, stderr
    expect(stdout).to include('install_defined=false')
    expect(stdout).to include('prepare_defined=true')
  end

  it 'prepends itself to javascript:install when that task already exists' do
    stdout, stderr, status = load_rake_file(define_install: true)

    expect(status).to be_success, stderr
    expect(stdout).to include('prereqs=javascript:prepare_node_path')
    expect(stdout).to include('prepare_defined=true')
  end

  def load_rake_file(define_install:)
    script = <<~RUBY
      require 'bundler/setup'
      require 'simplecov'
      module SilentFormatter
        def self.format(*)
        end
      end
      SimpleCov.formatter = SilentFormatter
      SimpleCov.command_name ENV.fetch('SIMPLECOV_COMMAND_NAME')
      SimpleCov.root File.expand_path('.')
      SimpleCov.start do
        enable_coverage :branch
        merge_timeout 3600
      end
      require 'rake'
      include Rake::DSL
      Rake.application = Rake::Application.new
      if ENV['DEFINE_JAVASCRIPT_INSTALL'] == '1'
        namespace :javascript do
          task :install
        end
      end
      load File.expand_path('lib/tasks/javascript_build.rake')
      if Rake::Task.task_defined?('javascript:install')
        puts "prereqs=\#{Rake::Task['javascript:install'].prerequisites.join(',')}"
      else
        puts 'install_defined=false'
      end
      puts "prepare_defined=\#{Rake::Task.task_defined?('javascript:prepare_node_path')}"
    RUBY
    Open3.capture3(
      {
        'SIMPLECOV_COMMAND_NAME' => "javascript-build-#{define_install}",
        'DEFINE_JAVASCRIPT_INSTALL' => define_install ? '1' : '0'
      },
      RbConfig.ruby,
      '-e',
      script
    )
  end
end
