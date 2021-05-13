# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/show.html.erb', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           FactoryBot.build(:admin)
                                                                         end)
    assign(:users, [
             User.create!(
               first_name: 'Admin',
               last_name: 'Test',
               email: 'admin3@example.com',
               password: 'admintest',
               password_confirmation: 'admintest',
               roles: 'admin'
             )
           ])
  end
end
