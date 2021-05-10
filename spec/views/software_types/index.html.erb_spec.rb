# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_types/index', type: :view do
  before(:each) do
    assign(:software_types, [
             SoftwareType.create!(
               title: 'Title',
               description: 'MyText'
             ),
             SoftwareType.create!(
               title: 'Title',
               description: 'MyText'
             )
           ])
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           FactoryBot.build(:admin)
                                                                         end)
  end
  it 'renders a list of software_types' do
    render
    assert_select 'td:nth-child(1)', text: 'Title'.to_s, count: 2
    expect(rendered).to_not have_text('MyText')
  end
end
