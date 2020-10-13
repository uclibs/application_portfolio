# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hosting_environments/index', type: :view do
  before(:each) do
    assign(:hosting_environments, [
             HostingEnvironment.create!(
               title: 'Test',
               description: 'test env.'
             )
           ])
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:admin) })
  end

  it 'renders a list of hosting_environments' do
    render
    assert_select 'td:nth-child(1)', text: 'Test'.to_s, count: 1
  end
end
