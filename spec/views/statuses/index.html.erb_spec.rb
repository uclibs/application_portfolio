# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'statuses/index', type: :view do
  before(:each) do
    assign(:statuses, [
             Status.create!(
               title: 'Test',
               status_type: 'Design'
             )
           ])
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           FactoryBot.build(:admin)
                                                                         end)
  end

  it 'renders a list of statuses' do
    render
    assert_select 'td:nth-child(1)', text: 'Test'.to_s, count: 1
  end
end
