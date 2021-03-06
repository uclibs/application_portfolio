# frozen_string_literal: true

FactoryBot.define do
  factory :viewer, class: 'User' do
    first_name { 'Random' }
    last_name { 'Viewer' }
    email { 'viewer@uc.edu' }
    password { 'random1234' }
    password_confirmation { 'random1234' }
    roles { 'viewer' }
  end

  factory :admin, class: 'User' do
    first_name { 'Random' }
    last_name { 'Admin' }
    email { 'admin@ucmail.uc.edu' }
    password { 'random1234' }
    password_confirmation { 'random1234' }
    roles { 'root_admin' }
  end

  factory :manager, class: 'User' do
    first_name { 'Random' }
    last_name { 'Manager' }
    email { 'manager@mail.uc.edu' }
    password { 'random1234' }
    password_confirmation { 'random1234' }
    roles { 'manager' }
  end

  factory :owner, class: 'User' do
    first_name { 'Random' }
    last_name { 'Owner' }
    email { 'owner@uc.edu' }
    password { 'random1234' }
    password_confirmation { 'random1234' }
    roles { 'owner' }
  end
end
