# frozen_string_literal: true

json.array! @software_records, partial: 'software_records/software_record', as: :software_record
