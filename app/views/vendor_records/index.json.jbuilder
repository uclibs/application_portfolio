# frozen_string_literal: true

json.array! @vendor_records, partial: 'vendor_records/vendor_record', as: :vendor_record
