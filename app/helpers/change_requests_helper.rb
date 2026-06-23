# frozen_string_literal: true

module ChangeRequestsHelper
  def find_software_name(pid)
    @pid = pid
    @software_name = SoftwareRecord.where(id: @pid).first.title
  end

  def find_software_version(pid)
    @pid = pid
    @software_version = SoftwareRecord.where(id: @pid).first.current_version
  end

  def convert_completed(value)
    @value = value
    @value_label = if @value == true
                     'Completed'
                   else
                     'Active'
                   end
  end

  def find_tech_leads(pid)
    @pid = pid
    @tech_lead = SoftwareRecord.where(id: @pid).first.tech_leads
  end

  def software_records_where_hash(pid)
    @pid = pid
    @software_record_hash = ChangeRequest.where(software_record_id: @pid.to_s)
  end
end
