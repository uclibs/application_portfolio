# frozen_string_literal: true

FactoryBot.define do
  factory :viewer, class: 'User' do
    first_name { 'Random' }
    last_name { 'Viewer' }
    email { 'viewer@test.com' }
    password { 'random123' }
    password_confirmation { 'random123' }
    roles { 'viewer' }
  end

  factory :admin, class: 'User' do
    first_name { 'Random' }
    last_name { 'Admin' }
    email { 'admin@test.com' }
    password { 'random123' }
    password_confirmation { 'random123' }
    roles { 'root_admin' }
  end

  factory :manager, class: 'User' do
    first_name { 'Random' }
    last_name { 'Manager' }
    email { 'manager@test.com' }
    password { 'random123' }
    password_confirmation { 'random123' }
    roles { 'manager' }
  end

  factory :owner, class: 'User' do
    first_name { 'Random' }
    last_name { 'Owner' }
    email { 'owner@test.com' }
    password { 'random123' }
    password_confirmation { 'random123' }
    roles { 'owner' }
  end
end
