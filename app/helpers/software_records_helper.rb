# frozen_string_literal: true

# SoftwareRecords Helper method
module SoftwareRecordsHelper
  def pills(status)
    if status == 'In Design'
      content_tag(:span, status, class: 'badge badge-pill badge-info')
    elsif status == 'In Development'
      content_tag(:span, status, class: 'badge badge-pill badge-light')
    elsif status == 'Production'
      content_tag(:span, status, class: 'badge badge-pill badge-primary')
    elsif status == 'Available'
      content_tag(:span, status, class: 'badge badge-pill badge-success')
    elsif status == 'To be decomissioned'
      content_tag(:span, status, class: 'badge badge-pill badge-danger')
    else
      content_tag(:span, status, class: 'badge badge-pill badge-dark')
    end
  end
end
