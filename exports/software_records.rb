# frozen_string_literal: true

# !/bin/env ruby
require 'csv'
require "#{Dir.pwd}/config/environment.rb"

# Export SoftwareRecords Data
class SoftwareRecords < ApplicationRecord
  def software_records
    file = "#{Dir.pwd}/public/software_records.csv"
    software_records = SoftwareRecords.all
    headers = ['Software Record', 'Description', 'Status', 'Created on', 'Software Type', 'Authentication Type', 'Vendor Record', 'Departments', 'Date Implemented', 'Date of upgrade', 'Developers', 'Tech Leads', 'Product Owners', 'Languages Used', 'Production URL', 'Source Code URL', 'User Seats', 'Annual Fees', 'Support Contract', 'Hosting Environment',
               'Current Version', 'Notes', 'Business Value', 'IT Quality', 'Created By']

    CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
      software_records.each do |software_record|
        tech_leads = software_record.tech_leads.to_s.gsub!('---', '').to_s
        tech_leads = tech_leads.gsub!(/\n/, '-').to_s
        all_tech_leads = tech_leads.split('- ')
        the_techleads = ''
        all_tech_lead_count = 0
        all_tech_leads.each do |each_tech_lead|
          if each_tech_lead.to_s == '-'
            all_tech_lead_count += 1
          else
            each_tech_lead = if each_tech_lead.include?('-')
                               each_tech_lead.gsub('-', '').to_s
                             else
                               each_tech_lead
                             end
            all_tech_lead_count += 1
            the_techleads += each_tech_lead
            the_techleads += ',' if all_tech_lead_count != all_tech_leads.size
          end
        end

        the_techleads = '' if the_techleads.to_s == "''"

        departments = software_record.departments.to_s.gsub!('---', '').to_s
        departments = departments.gsub!(/\n/, '-').to_s
        all_departments = departments.split('- ')
        the_departments = ''
        all_departments_count = 0
        all_departments.each do |each_department|
          if each_department.to_s == '-'
            all_departments_count += 1
          else
            each_department = if each_department.include?('-')
                                each_department.gsub('-', '').to_s
                              else
                                each_department
                              end
            all_departments_count += 1
            the_departments += each_department
            the_departments += ',' if all_departments_count != all_tech_leads.size
          end
        end

        the_departments = '' if the_departments.to_s == "''"

        developers = software_record.developers.to_s.gsub!('---', '').to_s
        developers = developers.gsub!(/\n/, '-').to_s
        all_developers = developers.split('- ')
        the_developers = ''
        all_developers_count = 0
        all_developers.each do |each_developer|
          if each_developer.to_s == '-'
            all_developers_count += 1
          else
            each_developer = if each_developer.include?('-')
                               each_developer.gsub('-', '').to_s
                             else
                               each_developer
                             end
            all_developers_count += 1
            the_developers += each_developer
            the_developers += ',' if all_developers_count != all_developers.size
          end
        end

        the_developers = '' if the_developers.to_s == "''"

        product_owners = software_record.product_owners.to_s.gsub!('---', '').to_s
        product_owners = product_owners.gsub!(/\n/, '-').to_s
        all_product_owners = product_owners.split('- ')
        the_product_owners = ''
        all_product_owners_count = 0
        all_product_owners.each do |each_product_owner|
          if each_product_owner.to_s == '-'
            all_product_owners_count += 1
          else
            each_product_owner = if each_product_owner.include?('-')
                                   each_product_owner.gsub('-', '').to_s
                                 else
                                   each_product_owner
                                 end
            all_product_owners_count += 1
            the_product_owners += each_product_owner
            the_product_owners += ',' if all_product_owners_count != all_product_owners.size
          end
        end

        the_product_owners = '' if the_product_owners.to_s == "''"

        writer << [software_record.title, software_record.description, Status.find_by(id: software_record.status_id).title, software_record.created_at, SoftwareType.find_by(id: software_record.software_type_id).title, software_record.authentication_type, VendorRecord.find_by(id: software_record.vendor_record_id).title, the_departments, software_record.date_implemented,
                   software_record.date_of_upgrade, the_developers, the_techleads, the_product_owners, software_record.languages_used, software_record.production_url, software_record.source_code_url, software_record.user_seats, software_record.annual_fees, software_record.support_contract, HostingEnvironment.find_by(id: software_record.hosting_environment_id).title, software_record.current_version, software_record.notes, software_record.business_value, software_record.it_quality, software_record.created_by]
      end
    end
  end
end

records = SoftwareRecords.new
records.software_records
