# frozen_string_literal: true

# VendorRecords helper method
module VendorRecordsHelper
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
end
