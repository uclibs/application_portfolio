# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hosting_environments/edit', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           FactoryBot.build(:admin)
                                                                         end)
    @hosting_environment = assign(:hosting_environment, HostingEnvironment.create!(
                                                          title: 'Test',
                                                          description: 'test env.'
                                                        ))
    params[:id] = 1
  end

  it 'renders the edit hosting_environment form' do
    render

    assert_select 'form[action=?][method=?]', hosting_environment_path(@hosting_environment),
                  'post' do
      assert_select 'input[name=?]', 'hosting_environment[title]'

      assert_select 'input[name=?]', 'hosting_environment[description]'
    end
  end
end
