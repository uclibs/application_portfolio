# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'front/profile', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:admin) })
    assign(:users, [
             User.create!(
               first_name: 'Admin',
               last_name: 'Test',
               email: 'admin12@uc.edu',
               password: 'admintest123',
               password_confirmation: 'admintest123',
               roles: 'admin'
             )
           ])
  end

  def sign_in_user(admin)
    sign_in admin
  end

  it 'displays an profile page' do
    render
    expect(rendered).to have_text('Profile')
    expect(rendered).to have_text(' Email')
    expect(rendered).to have_text('admin@ucmail.uc.edu')
  end

  it 'displays an user management tab' do
    render
    expect(rendered).to have_text('User Management')
    expect(rendered).to have_text('Admin Test')
  end
end

RSpec.describe 'front/profile', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:viewer) })
    assign(:users, [
             User.create!(
               first_name: 'Viewer',
               last_name: 'Test',
               email: 'viewer@uc.edu',
               password: 'viewertest',
               password_confirmation: 'viewertest',
               roles: 'viewer'
             )
           ])
  end

  def sign_in_user(admin)
    sign_in admin
  end

  it 'displays an profile page' do
    render
    expect(rendered).to have_text('Profile')
    expect(rendered).to have_text(' Email')
    expect(rendered).to have_text('viewer@uc.edu')
  end

  it 'displays an user management tab' do
    render
    expect(rendered).to have_text('User Management')
    expect(rendered).to have_text("You don't have sufficient privileges to view this content !")
  end
end

RSpec.describe 'front/profile', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:manager) })
    assign(:users, [
             User.create!(
               first_name: 'Manager',
               last_name: 'Test',
               email: 'manager@mail.uc.edu',
               password: 'managertest',
               password_confirmation: 'managertest',
               roles: 'manager'
             )
           ])
  end

  def sign_in_user(admin)
    sign_in admin
  end

  it 'displays an profile page' do
    render
    expect(rendered).to have_text('Profile')
    expect(rendered).to have_text(' Email')
    expect(rendered).to have_text('manager@mail.uc.edu')
  end

  it 'displays an user management tab' do
    render
    expect(rendered).to have_text('User Management')
    expect(rendered).to have_text("You don't have sufficient privileges to view this content !")
  end
end
