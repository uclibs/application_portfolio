# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'shared/_dashboard_header', type: :view do
  before do
    allow(view).to receive(:user_signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(FactoryBot.build_stubbed(:admin))
  end

  it 'renders the search field and button as a single input group' do
    render partial: 'shared/dashboard_header'

    expect(rendered).to have_css('.header-search-group.input-group .form-control + .header-search-btn')
    expect(rendered).not_to have_css('.header-search-btn.ms-2')
    expect(rendered).to have_css('form.header-search-form[action="/search"]')
  end
end
