# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    first_name { 'Random' }
    last_name { 'User' }
    email { 'random@gmail.com' }
    password { 'random123' }
    password_confirmation { 'random123' }
  end
end
