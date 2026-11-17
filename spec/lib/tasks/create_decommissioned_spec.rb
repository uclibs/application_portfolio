# frozen_string_literal: true

require 'rails_helper'
require 'open3'

# WorksResave is not defined in this repository. The task builds a
# Decommissioned status and discards it, so the row is never inserted.
#
# load_tasks reloads this rake file and SimpleCov resets the task body.
# A later example then stores that reset under the shared RSpec command
# name, so the resave and the Status.new have to be recorded in their own process.
RSpec.describe 'app_port:create_decom' do
  it 'resaves works and builds an unsaved Decommissioned status' do
    stdout, stderr, status = invoke_create_decommissioned_task

    expect(status).to be_success, stderr
    expect(stdout).to include('work_resave')
    expect(stdout).to include('prereqs=environment')
    expect(stdout).to include('built|Status|true|true|Decommissioned|Decommissioned')
    expect(stdout[/count_after=(\d+)/, 1]).to eq(stdout[/count_before=(\d+)/, 1])
  end

  def invoke_create_decommissioned_task
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
      SimpleCov.start('rails') do
        enable_coverage :branch
        merge_timeout 3600
      end
      module WorksResave
        def self.work_resave
          puts 'work_resave'
        end
      end
      require './config/environment'
      Rails.application.load_tasks
      task = Rake::Task['app_port:create_decom']
      puts "prereqs=\#{task.prerequisites.join(',')}"
      count = Status.count
      puts "count_before=\#{count}"
      Status.singleton_class.prepend(Module.new do
        def new(...)
          record = super
          puts ['built', record.class.name, record.new_record?, record.valid?, record.title, record.status_type].join('|')
          record
        end
      end)
      task.invoke
      puts "count_after=\#{Status.count}"
    RUBY
    Open3.capture3(
      {
        'SIMPLECOV_COMMAND_NAME' => 'create-decommissioned-task',
        'BUNDLE_PATH' => nil
      },
      RbConfig.ruby,
      '-e',
      script,
      chdir: Rails.root.to_s
    )
  end
end
