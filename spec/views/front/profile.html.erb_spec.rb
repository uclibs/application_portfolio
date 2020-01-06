# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'front/profile', type: :view do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  it 'displays an profile page' do
    render
    expect(rendered).to have_text('Profile')
    expect(rendered).to have_text('User Management')
  end
end
