# frozen_string_literal: true

# SoftwareRecords Helper method
module SoftwareRecordsHelper
  def pills(status)
    if status.to_s.downcase.include?('design')
      tag.span(status, class: 'badge badge-pill badge-dark')
    elsif status.to_s.downcase.include?('development')
      tag.span(status, class: 'badge badge-pill badge-info')
    elsif status.to_s.downcase.include?('upgrade')
      tag.span(status, class: 'badge badge-pill badge-warning')
    elsif status.to_s.downcase.include?('production')
      tag.span(status, class: 'badge badge-pill badge-primary')
    elsif status.to_s.downcase.include?('available')
      tag.span(status, class: 'badge badge-pill badge-success')
    elsif status.to_s.downcase.include?('decomission')
      tag.span(status, class: 'badge badge-pill badge-danger')
    else
      tag.span(status, class: 'badge badge-pill badge-light')
    end
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
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secret_key_base).generate_key salt, len
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
      @vendor_piechart_hash[vendor.title] = VendorRecord.find_by(id: vendor.id).software_records.count
    end
    @vendor_piechart_hash
  end

  def software_records_status_hash
    @software_status_piechart_hash = {}
    Status.all.each do |status|
      @software_status_piechart_hash[status.title] = Status.find_by(id: status.id).software_records.count
    end
    @software_status_piechart_hash
  end

  def yes_no_toggle(attr)
    @software_record.read_attribute(attr)
  end

  def true_false_toggle(_attr)
    value = true
    converted_value = if value
                        'true'
                      else
                        'false'
                      end
    converted_value = value ? 'Yes' : 'No'

  def software_records_upgrade_hash(software_pid)
    @software_pid = software_pid
    @software_upgrade_hash = {}
    @software_upgrade_hash = ChangeRequest.where(software_record_id: @software_pid.to_s, change_completed: true)
  end
end
