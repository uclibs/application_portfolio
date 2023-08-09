# frozen_string_literal: true

FactoryBot.define do
  factory :change_request do
    association :software_record, factory: :software_record
    change_title { 'MyString' }
    change_description { 'MyText' }
    change_completed { false }
    change_submitted_date { '2020-12-12' }
  end
end
