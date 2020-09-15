# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'statuses/show', type: :view do
  before(:each) do
    @status = assign(:status, Status.create!(
                                title: 'Test',
                                status_type: 'Design'
                              ))
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:admin) })
    session[:previous] = dashboard_path
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Test/)
    expect(rendered).to match(/Design/)
  end
end
