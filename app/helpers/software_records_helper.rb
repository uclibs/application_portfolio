# frozen_string_literal: true

# SoftwareRecords Helper method
module SoftwareRecordsHelper
  def pills(status)
    if status == 'In Design'
      content_tag(:span, status, class: 'badge badge-pill badge-light')
    elsif status == 'In Development'
      content_tag(:span, status, class: 'badge badge-pill badge-info')
    elsif status == 'In Upgrade'
      content_tag(:span, status, class: 'badge badge-pill badge-warning')
    elsif status == 'Production'
      content_tag(:span, status, class: 'badge badge-pill badge-primary')
    elsif status == 'Available'
      content_tag(:span, status, class: 'badge badge-pill badge-success')
    elsif status == 'To be decomissioned'
      content_tag(:span, status, class: 'badge badge-pill badge-danger')
    else
      content_tag(:span, status, class: 'badge badge-pill badge-info')
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, { sort: column, direction: direction }, class: css_class if column == 'vendor_record_id'
  end

  def sort_column
    SoftwareRecord.column_names.include?(params[:sort]) ? params[:sort] : 'title'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def encrypt(text)
    text = text.to_s unless text.is_a? String

    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.hex len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    encrypted_data = crypt.encrypt_and_sign text
    "#{salt}$$#{encrypted_data}"
  end

  def decrypt(text)
    salt, data = text.split '$$'

    len   = ActiveSupport::MessageEncryptor.key_len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    crypt.decrypt_and_verify data
  end

  def vendor_piechart
    @vendor_piechart_hash = {}
    VendorRecord.all.each do |vendor|
      @vendor_piechart_hash[vendor.title] = VendorRecord.find_by_id(vendor.id).software_records.count
    end
    @vendor_piechart_hash
  end

  def software_records_status_hash
    @software_status_piechart_hash = {}
    Status.all.each do |status|
      @software_status_piechart_hash[status.title] = Status.find_by_id(status.id).software_records.count
    end
    @software_status_piechart_hash
  end
end
