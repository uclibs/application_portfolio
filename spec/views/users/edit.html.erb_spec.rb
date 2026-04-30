# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/edit.html.erb', type: :view do
  let(:user) do
    User.create!(
      first_name: 'Admin',
      last_name: 'Test',
      email: 'admin2@uc.edu',
      roles: 'admin',
      department: 'Libraries',
      title: 'Analyst'
    )
  end

  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           FactoryBot.build(:admin)
                                                                         end)
    allow(view).to receive(:url_for).and_return("/users/#{user.id}/edit")
    assign(:user, user)
  end

  it 'renders locked identity fields and save/cancel controls' do
    assign(:safe_return_to, '/myprofile')

    render

    expect(rendered).to include('Save')
    expect(rendered).to include('Cancel')
    expect(rendered).to include('name="return_to"')
    expect(rendered).to include('value="/myprofile"')
    expect(rendered).to include('name="first_name"')
    expect(rendered).to include('name="last_name"')
    expect(rendered).to include('name="email"')
    expect(rendered).to include('readonly-field')
    expect(rendered).to include('aria-readonly="true"')
  end
end
