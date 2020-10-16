# frozen_string_literal: true

require 'csv'
require 'date'
# !/bin/env ruby
require Dir.pwd + '/config/environment.rb'
# Script for importing seeds data
class LoadRecords < ActiveRecord::Base
  def software_records
    file = Dir.pwd + '/public/uploads/' + $filename
    csv = CSV.read(file, headers: true)
    webapp_type = csv['Software Type']
    vendor_records = csv['Vendor Record']
    statuses = csv['Status']
    hosting_environments = csv['Hosting Environment']
    valid_types = []
    valid_vendors = []
    valid_statuses = []
    valid_hostings = []
    invalid_vendors = []
    invalid_types = []
    invalid_statuses = []
    invalid_hostings = []
    types_invalid = false
    vendors_invalid = false
    statuses_invalid = false
    hostings_invalid = false
    valid_types = []
    valid_vendors = []
    valid_statuses = []
    invalid_vendors = []
    invalid_types = []
    invalid_statuses = []
    types_invalid = false
    vendors_invalid = false
    statuses_invalid = false
    webapp_type.each do |type|
      valid_types.push(SoftwareType.find_by_title(type).id)
    rescue StandardError
      types_invalid = true
      invalid_types.push(type)
    end
    vendor_records.each do |record|
      valid_vendors.push(VendorRecord.find_by_title(record).id)
    rescue StandardError
      vendors_invalid = true
      invalid_vendors.push(record)
    end
    statuses.each do |status|
      valid_statuses.push(Status.find_by_title(status).id)
    rescue StandardError
      statuses_invalid = true
      invalid_statuses.push(status)
    end
    hosting_environments.each do |hosting_env|
      if hosting_env.to_s.strip.empty?
        valid_hostings.push(nil)
      else
        valid_hostings.push(HostingEnvironment.find_by_title(hosting_env).id)
      end
    rescue StandardError
      hostings_invalid = true
      invalid_hostings.push(hosting_env)
    end

    if types_invalid || vendors_invalid || statuses_invalid || hostings_invalid
      puts '---------------------------------------------------------------------'
      puts('No Software Records created due to following in-valid records/types/statuses/hosting environments..')

    if types_invalid || vendors_invalid || statuses_invalid
      puts '---------------------------------------------------------------------'
      puts('No Software Records created due to following in-valid records/types/statuses..')
      puts '---------------------------------------------------------------------'
      puts('In-Valid Vendor Records')
      puts('-----------------------------')
      puts(invalid_vendors)
      puts('-----------------------------')
      puts('In-Valid Software Types')
      puts('-----------------------------')
      puts(invalid_types)
      puts('-----------------------------')
      puts('In-Valid Statuses')
      puts('-----------------------------')
      puts(invalid_statuses)
      puts('-----------------------------')
      puts('In-Valid Hosting Env.')
      puts('-----------------------------')
      puts(invalid_hostings)
    else
      count = 0
      created = 0
      csv.each do |row|
        title = row['Software Record']
        desc = row['Description']
        software_type_id = valid_types[count]
        vendor_record_id = valid_vendors[count]
        status_id = valid_statuses[count]
        hosting_environment_id = if valid_hostings[count].nil?
                                   HostingEnvironment.find_by_title('None').id
                                 else
                                   valid_hostings[count]
                                 end

        departments = []
        if row['Departments'].to_s.include?(',')
          alldeps = row['Departments'].split(',')
          alldeps.each do |dep|
            dep = dep.to_s.strip
            departments.push(dep)
          end
        else
          departments.push(row['Departments'])
        end

        developers = []

        if !row['Developers'].to_s.empty?
          if row['Developers'].to_s.include?(',')
            alldevs = row['Developers'].split(',')
            alldevs.each do |dev|
              dev = dev.to_s.strip
              developers.push(dev)
            end
          else
            developers.push(row['Developers'])
          end
        else
          developers.push('')
        end

        tech_leads = []

        if !row['Tech Leads'].to_s.empty?
          if row['Tech Leads'].to_s.include?(',')
            alltechleads = row['Tech Leads'].split(',')
            alltechleads.each do |lead|
              lead = lead.to_s.strip
              tech_leads.push(lead)
            end
          else
            tech_leads.push(row['Tech Leads'])
          end
        else
          tech_leads.push('')
        end

        product_owners = []

        if !row['Product Owners'].to_s.empty?
          if row['Product Owners'].to_s.include?(',')
            allproductowners = row['Product Owners'].split(',')
            allproductowners.each do |owner|
              owner = owner.to_s.strip
              product_owners.push(owner)
            end
          else
            product_owners.push(row['Product Owners'])
          end
        else
          product_owners.push('')
        end

        date_implemented = row['Date Implemented'].to_s.strip
        lang = row['Languages Used'].to_s.strip
        url = row['Production URL'].to_s.strip
        source_url = row['Source Code URL'].to_s.strip
        user_seats = row['User Seats'].to_s.strip
        annual_fees = row['Annual Fees'].to_s.strip
        support_contract = row['Support Contract'].to_s.strip
        hosting = row['Hosting Environment'].to_s.strip
        version = row['Current Version'].to_s.strip
        notes = row['Notes'].to_s.strip
        bvalue = row['Business value'].to_s.strip
        itquality = row['IT quality'].to_s.strip
        created_by = $user
        sensitive_information = row['Sensitive Information'].to_s.strip
        date_of_upgrade = row['Date of upgrade'].to_s.strip

        if !SoftwareRecord.find_by_title(title).nil? && SoftwareRecord.find_by_title(title).title.to_s == title && SoftwareRecord.find_by_title(title).software_type_id == software_type_id && SoftwareRecord.find_by_title(title).vendor_record_id == vendor_record_id
          puts("Software Record '#{title}' is found in the db and hence suppressing it.")
        else
          SoftwareRecord.new(title: title, description: desc, status_id: status_id, software_type_id: software_type_id,
                             vendor_record_id: vendor_record_id, departments: departments, date_implemented: date_implemented,
                             developers: developers, tech_leads: tech_leads, product_owners: product_owners, languages_used: lang,
                             production_url: url, source_code_url: source_url, user_seats: user_seats, annual_fees: annual_fees, support_contract: support_contract,
                             hosting_environment_id: hosting_environment_id, current_version: version, notes: notes, business_value: bvalue,
                             it_quality: itquality, created_by: created_by, sensitive_information: sensitive_information,
                             date_of_upgrade: date_of_upgrade).save
          created += 1
          puts("Created Software Record '" + row['Software Record'] + "'...")
        end
        count += 1
      end
      puts '---------------------------------------------------------------------'
      puts "Total Software Records created -> #{created}"
      puts '---------------------------------------------------------------------'
    end
  end

  def vendor_records
    file = Dir.pwd + '/public/uploads/' + $filename
    csv = CSV.read(file, headers: true)
    vendor_records = csv['Vendor Record']
    duplicate_vendors = []
    vendors_exists = false
    valid_vendors = []
    count = 1
    vendor_records.each do |record|
      VendorRecord.find_by_title(record).id
    rescue StandardError
      vendors_exists = false
      valid_vendors.push(record)
    else
      vendors_exists = true
      duplicate_vendors.push(record)
    end
    duplicate_vendors = duplicate_vendors.uniq
    valid_vendors = valid_vendors.uniq

    puts 'Duplicate Vendor Records exists and suppressing them...' if vendors_exists
    valid_vendors.each do |eachrecord|
      count += 1
      puts "Creating Vendor Record '" + eachrecord.to_s + "'"
      VendorRecord.new(title: eachrecord, description: '-').save
    end
    puts '---------------------------------------------------------------------'
    puts "Total Vendor Records created -> #{count - 1}"
    puts '---------------------------------------------------------------------'
  end

  def software_types
    file = Dir.pwd + '/public/uploads/' + $filename
    csv = CSV.read(file, headers: true)
    software_types = csv['Software Type']
    duplicate_types = []
    types_exists = false
    valid_types = []
    count = 1
    software_types.each do |type|
      SoftwareType.find_by_title(type).id
    rescue StandardError
      types_exists = false
      valid_types.push(type)
    else
      types_exists = true
      duplicate_types.push(type)
    end
    duplicate_types = duplicate_types.uniq
    valid_types = valid_types.uniq

    puts 'Duplicate Software Types exists and suppressing them...' if types_exists
    valid_types.each do |eachtype|
      count += 1
      puts "Creating Software Type '" + eachtype.to_s + "'"
      SoftwareType.new(title: eachtype, description: '-').save
    end
    puts '---------------------------------------------------------------------'
    puts "Total Software Types created -> #{count - 1}"
    puts '---------------------------------------------------------------------'
  end

  def statuses
    file = Dir.pwd + '/public/uploads/' + $filename
    csv = CSV.read(file, headers: true)
    all_statuses = csv['Status']
    duplicate_statuses = []
    statuses_exists = false
    valid_statuses = []
    count = 1
    all_statuses.each do |status|
      Status.find_by_title(status).id
    rescue StandardError
      statuses_exists = false
      valid_statuses.push(status)
    else
      statuses_exists = true
      duplicate_statuses.push(status)
    end
    duplicate_statuses = duplicate_statuses.uniq
    valid_statuses = valid_statuses.uniq

    puts 'Duplicate Statuses exists and suppressing them...' if statuses_exists
    valid_statuses.each do |eachstatus|
      count += 1
      puts "Creating Status '" + eachstatus.to_s + "'"
      Status.new(title: eachstatus).save
    end
    puts '---------------------------------------------------------------------'
    puts "Total Statuses created -> #{count - 1}"
    puts '---------------------------------------------------------------------'
  end

  def hosting_envs
    file = Dir.pwd + '/public/uploads/' + $filename
    csv = CSV.read(file, headers: true)
    all_hostings = csv['Hosting Environment']
    duplicate_hostings = []
    hostings_exists = false
    valid_hostings = []
    count = 1
    all_hostings.each do |hosting|
      HostingEnvironment.find_by_title(hosting).id
    rescue StandardError
      hostings_exists = false
      valid_hostings.push(hosting)
    else
      hostings_exists = true
      duplicate_hostings.push(hosting)
    end
    duplicate_hostings = duplicate_hostings.uniq
    valid_hostings = valid_hostings.uniq

    puts 'Duplicate Statuses exists and suppressing them...' if hostings_exists
    valid_hostings.each do |eachenv|
      count += 1
      puts "Creating Hosting Environment '" + eachenv.to_s + "'"
      HostingEnvironment.new(title: eachenv).save
    end
    puts '---------------------------------------------------------------------'
    puts "Total Hosting Environments created -> #{count - 1}"
    puts '---------------------------------------------------------------------'
  end
end

args = ARGV[0]
$filename = ARGV[1]
$user = ARGV[2]

if args == 'vendor'
  LoadRecords.table_name = 'vendor_records'
  l = LoadRecords.new
  l.vendor_records
elsif args == 'software'
  LoadRecords.table_name = 'software_records'
  l = LoadRecords.new
  l.software_records
elsif args == 'type'
  LoadRecords.table_name = 'software_types'
  l = LoadRecords.new
  l.software_types
elsif args == 'status'
  LoadRecords.table_name = 'statuses'
  l = LoadRecords.new
  l.statuses
elsif args == 'hosting_env'
  LoadRecords.table_name = 'hosting_environments'
  l = LoadRecords.new
  l.hosting_envs
else
  puts "Invalid arguments...\nTry passing...\n 1) `vendor` to import vendor_records data, \n 2) `software` to import software_records data, \n 3) `type` to import software_types data, \n 4) `status` to import status data, \n 5) `hosting_env` to import hosting_environment data"
end
