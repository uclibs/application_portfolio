# frozen_string_literal: true

json.array! @change_requests, partial: 'change_requests/change_request',
                              as: :change_request
