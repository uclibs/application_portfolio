# frozen_string_literal: true

FactoryBot.define do
  factory :status do
    title { 'Available' }
    status_type { 'Other' }
  end
end
