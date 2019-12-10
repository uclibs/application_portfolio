# frozen_string_literal: true

require 'rails_helper'

describe 'front/dashboard' do
  it 'displays an dashboard page' do
    render
    expect(rendered).to have_text('Users')
    expect(rendered).to have_text('Software Records')
    expect(rendered).to have_text('Software Types')
    expect(rendered).to have_text('Vendor Records')
  end
end
