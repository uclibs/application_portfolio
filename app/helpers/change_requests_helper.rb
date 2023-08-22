# frozen_string_literal: true

module ChangeRequestsHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column) && (sort_direction == 'asc' ? 'desc' : 'asc')
    link_to title, sort: column, direction:, class: 'th-link'
  end

  def sort_column
    VendorRecord.column_names.include?(params[:sort]) ? params[:sort] : 'title'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

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
    @tech_lead.each do |element|
      element
    end
  end

  def software_records_where_hash(pid)
    @pid = pid
    @software_record_hash = {}
    @software_record_hash = ChangeRequest.where(software_record_id: @pid.to_s)
    #    @software_record_hash = ChangeRequest.joins(:software_record).where('software_records.id = ?', @id)
  end
end
