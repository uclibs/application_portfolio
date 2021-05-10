# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hosting_environments/show', type: :view do
  before(:each) do
    @hosting_environment = assign(:hosting_environment, HostingEnvironment.create!(
                                                          title: 'Test',
                                                          description: 'test env.'
                                                        ))
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           FactoryBot.build(:admin)
                                                                         end)
    session[:previous] = dashboard_path
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Test/)
    expect(rendered).to match(/test env./)
  end
end
