# frozen_string_literal: true

FactoryBot.define do
  factory :vendor_record do
    name { 'MyString' }
    description { 'MyText' }
    date_started { '2019-11-25' }
  end
end
