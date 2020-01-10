# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'front/profile', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:admin) })
  end

  it 'displays an profile page' do
    render
    expect(rendered).to have_text('Profile')
    expect(rendered).to have_text('User Management')
  end
end
