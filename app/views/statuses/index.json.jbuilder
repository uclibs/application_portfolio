# frozen_string_literal: true

json.array! @statuses, partial: 'statuses/status', as: :status
