# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index.html.erb', type: :view do
  before(:each) do
    @user = assign(:user, [User.create!(
      first_name: 'Admin',
      last_name: 'Test',
      email: 'admin1@example.com',
      password: 'admintest',
      password_confirmation: 'admintest',
      roles: 'admin'
    )])
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           @user
                                                                         end)
  end
end
