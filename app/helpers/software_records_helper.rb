# frozen_string_literal: true

# SoftwareRecords Helper method
module SoftwareRecordsHelper
  STATUS_BADGE_CLASSES = [
    %w[design text-bg-dark],
    %w[development text-bg-info],
    %w[upgrade text-bg-warning],
    %w[production text-bg-primary],
    %w[available text-bg-success],
    %w[decomission text-bg-danger]
  ].freeze

  DEFAULT_STATUS_BADGE_CLASS = 'text-bg-light'

  def pills(status)
    normalized_status = status.to_s.downcase
    badge_class = STATUS_BADGE_CLASSES.find { |matcher, _| normalized_status.include?(matcher) }&.last ||
                  DEFAULT_STATUS_BADGE_CLASS

    tag.span(status, class: "badge rounded-pill #{badge_class}")
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
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secret_key_base).generate_key salt, len
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

  # Returns the raw DB value for form radio checked state (compared to "Yes"/"No" in views).
  def yes_no_toggle(attr)
    @software_record.read_attribute(attr)
  end

  # Formats a boolean (or boolean-like) value for read-only display.
  def yes_no_label(value)
    ActiveModel::Type::Boolean.new.cast(value) ? 'Yes' : 'No'
  end

  def software_records_upgrade_hash(software_pid)
    @software_pid = software_pid
    @software_upgrade_hash = ChangeRequest.where(software_record_id: @software_pid.to_s, change_completed: true)
  end
end
