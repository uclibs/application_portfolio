# frozen_string_literal: true

require 'rails_helper'
require 'csv'
require 'fileutils'
require 'open3'
require "#{Dir.pwd}/load_records.rb"

SOFTWARE_RECORD_HEADERS = [
  'Software Record', 'Description', 'Software Type', 'Vendor Record', 'Status', 'Hosting Environment',
  'Departments', 'Developers', 'Tech Leads', 'Product Owners', 'Admin Users', 'Date Implemented',
  'Languages Used', 'Production URL', 'Source Code URL', 'User Seats', 'Annual Fees', 'Support Contract',
  'Current Version', 'Notes', 'Business value', 'IT quality', 'Sensitive Information', 'Date of upgrade',
  'Authentication Type', 'Requires Chanage Management review?', 'Last Security Scan', 'Last Accessibility Scan',
  'Last OGC Review', 'Last Infosec Review', 'CM Stakeholders', 'CM Other Notes', 'QA URL', 'Dev URL',
  'Prod URL', 'Production Support Servers', 'Last Record Change', 'Track Uptime', 'Monitor Health',
  'Monitor Errors'
].freeze

module LoadRecordsCsvHelper
  def write_upload(headers, rows)
    @csv_path = Rails.root.join('public/uploads', "load-records-#{SecureRandom.hex(6)}.csv")
    FileUtils.mkdir_p(@csv_path.dirname)
    CSV.open(@csv_path, 'w') do |csv|
      csv << headers
      rows.each { |row| csv << headers.map { |header| row[header] } }
    end
    assign_script_global('$filename', @csv_path.basename.to_s)
  end

  # The importer reads $filename and $user. Ruby 4 removed Kernel#global_variable_set,
  # so the assignment is built as a literal and run on the top-level object.
  def assign_script_global(name, value)
    TOPLEVEL_BINDING.receiver.instance_eval("#{name} = #{value.inspect}", __FILE__, __LINE__)
  end
end

RSpec.shared_context 'with load records csv cleanup' do
  include LoadRecordsCsvHelper

  after do
    FileUtils.rm_f(@csv_path) if @csv_path
    LoadRecords.reset_table_name
  end
end

RSpec.describe LoadRecords, '#software_records' do
  include_context 'with load records csv cleanup'
  let!(:web_app) { FactoryBot.create(:software_type, title: 'Web App') }
  let!(:database) { FactoryBot.create(:software_type, title: 'Database') }
  let!(:acme) { FactoryBot.create(:vendor_record, title: 'Acme') }
  let!(:other_vendor) { FactoryBot.create(:vendor_record, title: 'Other Vendor') }
  let!(:active_status) { FactoryBot.create(:status, title: 'Active') }
  let!(:aws) { FactoryBot.create(:hosting_environment, title: 'AWS') }
  let!(:none_hosting) { FactoryBot.create(:hosting_environment, title: 'None') }

  def software_row(overrides = {})
    {
      'Software Record' => 'Portal',
      'Description' => 'Library portal',
      'Software Type' => web_app.title,
      'Vendor Record' => acme.title,
      'Status' => active_status.title,
      'Hosting Environment' => aws.title,
      'Departments' => 'Solo',
      'Developers' => 'Ada',
      'Tech Leads' => 'Tess',
      'Product Owners' => 'Olivia',
      'Admin Users' => 'Alex',
      'Date Implemented' => '2024-01-15',
      'Languages Used' => 'Ruby',
      'Production URL' => 'https://portal.example.edu',
      'Source Code URL' => 'https://github.example.edu/portal',
      'User Seats' => '25',
      'Annual Fees' => '1000',
      'Support Contract' => 'Standard',
      'Current Version' => '1.2.3',
      'Notes' => 'Imported',
      'Business value' => '3',
      'IT quality' => '2',
      'Sensitive Information' => 'restricted',
      'Date of upgrade' => '2024-06-01',
      'Authentication Type' => 'Shibboleth',
      'Requires Chanage Management review?' => 'yes',
      'Last Security Scan' => '2024-05-01',
      'Last Accessibility Scan' => '2024-05-02',
      'Last OGC Review' => '2024-05-03',
      'Last Infosec Review' => '2024-05-04',
      'CM Stakeholders' => 'Libraries',
      'CM Other Notes' => 'none',
      'QA URL' => 'https://qa.example.edu',
      'Dev URL' => 'https://dev.example.edu',
      'Prod URL' => 'https://prod.example.edu',
      'Production Support Servers' => 'app01',
      'Last Record Change' => '2024-07-01',
      'Track Uptime' => 'yes',
      'Monitor Health' => 'yes',
      'Monitor Errors' => 'yes'
    }.merge(overrides)
  end

  def import_software(rows)
    write_upload(SOFTWARE_RECORD_HEADERS, rows)
    assign_script_global('$user', 'Import User')
    LoadRecords.table_name = 'software_records'
    LoadRecords.new.software_records
  end

  it 'creates records for every list shape and skips an exact duplicate' do
    rows = [
      software_row(
        'Departments' => 'Alpha, Beta',
        'Developers' => 'Ann, Ben',
        'Tech Leads' => 'Tia, Theo',
        'Product Owners' => 'Pat, Pam',
        'Admin Users' => 'Ada, Al'
      ),
      software_row(
        'Software Record' => 'Other App',
        'Hosting Environment' => '   ',
        'Departments' => 'Solo Dept',
        'Developers' => '',
        'Tech Leads' => '',
        'Product Owners' => '',
        'Admin Users' => ''
      ),
      software_row('Software Record' => 'Third App'),
      software_row('Software Type' => database.title),
      software_row('Vendor Record' => other_vendor.title),
      software_row
    ]

    expect { import_software(rows) }.to output(
      a_string_including('Total Software Records created -> 5')
        .and(a_string_including("Software Record 'Portal' is found in the db and hence suppressing it."))
    ).to_stdout

    created = SoftwareRecord.order(:id).to_a
    expect(created.map(&:title)).to eq(['Portal', 'Other App', 'Third App', 'Portal', 'Portal'])
    expect(created.first.departments).to eq(%w[Alpha Beta])
    expect(created.first.developers).to eq(%w[Ann Ben])
    expect(created.first.tech_leads).to eq(%w[Tia Theo])
    expect(created.first.product_owners).to eq(%w[Pat Pam])
    expect(created.first.admin_users).to eq(%w[Ada Al])
    expect(created.first.hosting_environment_id).to eq(aws.id)
    expect(created.second.developers).to eq([''])
    expect(created.second.tech_leads).to eq([''])
    expect(created.second.product_owners).to eq([''])
    expect(created.second.admin_users).to eq([''])
    expect(created.second.hosting_environment_id).to eq(none_hosting.id)
    expect(created.third.developers).to eq(['Ada'])
    expect(created.third.created_by).to eq('Import User')
  end

  it 'creates a record when the title lookup does not match the imported title' do
    decoy = SoftwareRecord.new(title: 'Decoy', software_type_id: web_app.id, vendor_record_id: acme.id)
    allow(SoftwareRecord).to receive(:find_by).and_return(decoy)

    expect { import_software([software_row]) }.to output(
      a_string_including("Created Software Record 'Portal'...")
    ).to_stdout
    expect(SoftwareRecord.find_by(title: 'Portal')).to be_present
  end

  it 'does not create software records when a software type is unknown' do
    expect do
      import_software([software_row('Software Type' => 'Missing Type')])
    end.to output(a_string_including('Missing Type').and(a_string_including('No Software Records created'))).to_stdout

    expect(SoftwareRecord.count).to eq(0)
  end

  it 'does not create software records when a vendor is unknown' do
    expect do
      import_software([software_row('Vendor Record' => 'Missing Vendor')])
    end.to output(a_string_including('Missing Vendor').and(a_string_including('No Software Records created'))).to_stdout

    expect(SoftwareRecord.count).to eq(0)
  end

  it 'does not create software records when a status is unknown' do
    expect do
      import_software([software_row('Status' => 'Missing Status')])
    end.to output(a_string_including('Missing Status').and(a_string_including('No Software Records created'))).to_stdout

    expect(SoftwareRecord.count).to eq(0)
  end

  it 'does not create software records when a hosting environment is unknown' do
    expect do
      import_software([software_row('Hosting Environment' => 'Missing Host')])
    end.to output(a_string_including('Missing Host').and(a_string_including('No Software Records created'))).to_stdout

    expect(SoftwareRecord.count).to eq(0)
  end
end

RSpec.shared_examples 'a titled csv importer' do |importer|
  include_context 'with load records csv cleanup'

  def import_titled(rows, importer)
    column = importer[:column]
    write_upload([column], rows.map { |title| { column => title } })
    LoadRecords.table_name = importer[:table_name]
    LoadRecords.new.public_send(importer[:method_name])
  end

  it 'creates each distinct new title' do
    expect { import_titled(['Brand New', 'Brand New', 'Second'], importer) }.to output(
      a_string_including("#{importer[:created_word]} 'Brand New'")
        .and(a_string_including("#{importer[:created_word]} 'Second'"))
        .and(a_string_including("#{importer[:total_label]} -> 2"))
    ).to_stdout

    expect(importer[:model].where(title: ['Brand New', 'Second']).count).to eq(2)
  end

  it 'suppresses titles that are already stored' do
    FactoryBot.create(importer[:factory], title: 'Existing')

    expect { import_titled(%w[Existing Existing], importer) }.to output(
      a_string_including(importer[:duplicate_message]).and(a_string_including("#{importer[:total_label]} -> 0"))
    ).to_stdout

    expect(importer[:model].where(title: 'Existing').count).to eq(1)
  end
end

RSpec.describe LoadRecords, '#vendor_records' do
  it_behaves_like 'a titled csv importer', {
    method_name: :vendor_records,
    column: 'Vendor Record',
    model: VendorRecord,
    factory: :vendor_record,
    duplicate_message: 'Duplicate Vendor Records exists and suppressing them...',
    created_word: 'Creating Vendor Record',
    total_label: 'Total Vendor Records created',
    table_name: 'vendor_records'
  }
end

RSpec.describe LoadRecords, '#software_types' do
  it_behaves_like 'a titled csv importer', {
    method_name: :software_types,
    column: 'Software Type',
    model: SoftwareType,
    factory: :software_type,
    duplicate_message: 'Duplicate Software Types exists and suppressing them...',
    created_word: 'Creating Software Type',
    total_label: 'Total Software Types created',
    table_name: 'software_types'
  }
end

RSpec.describe LoadRecords, '#statuses' do
  it_behaves_like 'a titled csv importer', {
    method_name: :statuses,
    column: 'Status',
    model: Status,
    factory: :status,
    duplicate_message: 'Duplicate Statuses exists and suppressing them...',
    created_word: 'Creating Status',
    total_label: 'Total Statuses created',
    table_name: 'statuses'
  }
end

RSpec.describe LoadRecords, '#hosting_envs' do
  it_behaves_like 'a titled csv importer', {
    method_name: :hosting_envs,
    column: 'Hosting Environment',
    model: HostingEnvironment,
    factory: :hosting_environment,
    duplicate_message: 'Duplicate Hosting Environments exists and suppressing them...',
    created_word: 'Creating Hosting Environment',
    total_label: 'Total Hosting Environments created',
    table_name: 'hosting_environments'
  }
end

# The dispatcher at the bottom of load_records.rb runs only when that file is
# the main program. A second load in this process would reset SimpleCov for the
# file, so each command runs in its own process and the reports are merged.
RSpec.describe LoadRecords, 'command line' do
  def run_importer(argument)
    script = <<~RUBY
      require 'bundler/setup'
      require 'simplecov'
      module SilentFormatter
        def self.format(*)
        end
      end
      SimpleCov.formatter = SilentFormatter
      SimpleCov.command_name ENV.fetch('SIMPLECOV_COMMAND_NAME')
      SimpleCov.start do
        enable_coverage :branch
        merge_timeout 3600
      end
      require './config/environment'
      TracePoint.new(:end) do |trace|
        next unless trace.self.is_a?(Class) && trace.self.name == 'LoadRecords'

        def LoadRecords.new(*)
          Object.new.tap do |loader|
            %i[vendor_records software_records software_types statuses hosting_envs].each do |name|
              loader.define_singleton_method(name) { puts "CALLED \#{name}" }
            end
          end
        end
        trace.disable
      end.enable
      path = File.expand_path('load_records.rb')
      $PROGRAM_NAME = path
      load path
    RUBY
    Open3.capture2(
      { 'SIMPLECOV_COMMAND_NAME' => "load-records-#{argument}", 'RAILS_ENV' => 'test', 'DISABLE_SPRING' => '1' },
      RbConfig.ruby, '-e', script, argument, 'unused.csv', 'Importer'
    )
  end

  it 'imports vendor records' do
    output, status = run_importer('vendor')
    expect(status).to be_success
    expect(output).to include('CALLED vendor_records')
  end

  it 'imports software records' do
    output, status = run_importer('software')
    expect(status).to be_success
    expect(output).to include('CALLED software_records')
  end

  it 'imports software types' do
    output, status = run_importer('type')
    expect(status).to be_success
    expect(output).to include('CALLED software_types')
  end

  it 'imports statuses' do
    output, status = run_importer('status')
    expect(status).to be_success
    expect(output).to include('CALLED statuses')
  end

  it 'imports hosting environments' do
    output, status = run_importer('hosting_env')
    expect(status).to be_success
    expect(output).to include('CALLED hosting_envs')
  end

  it 'prints usage for an unknown command' do
    output, status = run_importer('bogus')
    expect(status).to be_success
    expect(output).to include('Invalid arguments')
  end
end
