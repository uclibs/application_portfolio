# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'front/profile', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           FactoryBot.build_stubbed(:admin)
                                                                         end)
    assign(:users, [
             User.create!(
               first_name: 'Admin',
               last_name: 'Test',
               email: 'admin12@uc.edu',
               roles: 'admin'
             )
           ])
  end

  def sign_in_user(admin)
    sign_in admin
  end

  it 'displays an profile page' do
    render
    expect(rendered).to include('Profile')
    expect(rendered).to include(' Email')
    expect(rendered).to include('admin@ucmail.uc.edu')
    expect(rendered).not_to match(/tab-pane[^>]*color:\s*white/i)
  end

  it 'displays an user management tab' do
    render
    expect(rendered).to include('User Management')
    expect(rendered).to include('Admin Test')
  end
end

RSpec.describe 'front/profile', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           FactoryBot.build_stubbed(:viewer)
                                                                         end)
    assign(:users, [
             User.create!(
               first_name: 'Viewer',
               last_name: 'Test',
               email: 'viewer@uc.edu',
               roles: 'viewer'
             )
           ])
  end

  def sign_in_user(admin)
    sign_in admin
  end

  it 'displays an profile page' do
    render
    expect(rendered).to include('Profile')
    expect(rendered).to include(' Email')
    expect(rendered).to include('viewer@uc.edu')
  end

  it 'displays an user management tab' do
    render
    expect(rendered).to include('User Management')
    expect(rendered.squish).to include("You don't have sufficient privileges to view this content!")
  end
end

RSpec.describe 'front/profile', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           FactoryBot.build_stubbed(:manager)
                                                                         end)
    assign(:users, [
             User.create!(
               first_name: 'Manager',
               last_name: 'Test',
               email: 'manager@mail.uc.edu',
               roles: 'manager'
             )
           ])
  end

  def sign_in_user(admin)
    sign_in admin
  end

  it 'displays an profile page' do
    render
    expect(rendered).to include('Profile')
    expect(rendered).to include(' Email')
    expect(rendered).to include('manager@mail.uc.edu')
  end

  it 'displays an user management tab' do
    render
    expect(rendered).to include('User Management')
    expect(rendered.squish).to include("You don't have sufficient privileges to view this content!")
  end
end
