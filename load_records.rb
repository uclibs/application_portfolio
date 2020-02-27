# frozen_string_literal: true

require 'csv'
require 'date'
# !/bin/env ruby
ENV['RAILS_ENV'] = 'development'
require Dir.pwd + '/config/environment.rb'
# Script for importing seeds data
class LoadRecords < ActiveRecord::Base
  def software_records
    file = Dir.pwd + '/public/uploads/' + $filename
    csv = CSV.read(file, headers: true)
    webapp_type = csv['Type']
    vendor_records = csv['Vendor']
    valid_types = []
    valid_vendors = []
    invalid_vendors = []
    invalid_types = []
    types_invalid = false
    vendors_invalid = false
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

    if types_invalid || vendors_invalid
      puts '---------------------------------------------------------------------'
      puts('No Software Records created due to following in-valid records/types..')
      puts '---------------------------------------------------------------------'
      puts('In-Valid Vendor Records')
      puts('-----------------------------')
      puts(invalid_vendors)
      puts('-----------------------------')
      puts('In-Valid Software Types')
      puts('-----------------------------')
      puts(invalid_types)
    else
      count = 0
      csv.each do |row|
        title = row['Title']
        desc = row['Description']
        status = row['Status']
        software_type_id = valid_types[count]
        vendor_record_id = valid_vendors[count]

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
            alldevs = row['Departments'].split(',')
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

        if !row['Tech Leads'].to_s.empty?
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

        date_implemented = row['Date Implemented'].to_s
        lang = row['Languages or frameworks'].to_s.strip
        url = row['URL'].to_s.strip
        user_seats = row['# of User seats'].to_s.strip
        annual_fees = row['Annual Fees'].to_s.strip
        support_contract = row['Support Contract'].to_s.strip
        hosting = row['Hosting environment/servers'].to_s.strip
        version = row['Current Version'].to_s.strip
        notes = row['Notes'].to_s.strip
        bvalue = row['Business value'].to_s.strip
        itquality = row['IT quality'].to_s.strip
        tentative = row['Date submitted to portfolio']
        created_by = $user
        sensitive_information = row['Sensitive Information'].to_s.strip
        date_of_upgrade = row['Date of Upgrade'].to_s.strip

        SoftwareRecord.new(title: title, description: desc, status: status, software_type_id: software_type_id,
                           vendor_record_id: vendor_record_id, departments: departments, date_implemented: date_implemented,
                           developers: developers, tech_leads: tech_leads, product_owners: product_owners, languages_used: lang,
                           url: url, user_seats: user_seats, annual_fees: annual_fees, support_contract: support_contract,
                           hosting_environment: hosting, current_version: version, notes: notes, business_value: bvalue,
                           it_quality: itquality, tentative_date_implemented: tentative, created_by: created_by, sensitive_information: sensitive_information,
                           date_of_upgrade: date_of_upgrade).save
        count += 1
        puts("Created Software Record '" + row['Title'] + "'...")
      end
      puts '---------------------------------------------------------------------'
      puts "Total Software Records created -> #{count + 1}"
      puts '---------------------------------------------------------------------'
    end
  end

  def vendor_records
    file = Dir.pwd + '/public/uploads/' + $filename
    csv = CSV.read(file, headers: true)
    vendor_records = csv['Vendor']
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
      VendorRecord.new(title: eachrecord, description: 'test').save
    end
    puts '---------------------------------------------------------------------'
    puts "Total Vendor Records created -> #{count - 1}"
    puts '---------------------------------------------------------------------'
  end

  def software_types
    file = Dir.pwd + '/public/uploads/' + $filename
    csv = CSV.read(file, headers: true)
    software_types = csv['Type']
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
      SoftwareType.new(title: eachtype, description: 'test').save
    end
    puts '---------------------------------------------------------------------'
    puts "Total Software Types created -> #{count - 1}"
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
else
  puts "Invalid arguments...\nTry passing...\n 1) `vendor` to import vendor_records data, \n 2) `software` to import software_records data, \n 3) `type` to import software_types data."
end
