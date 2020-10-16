# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hosting_environments/new', type: :view do
  before(:each) do
    assign(:hosting_environment, HostingEnvironment.new(
                                   title: 'Test',
                                   description: 'test env.'
                                 ))
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:admin) })
  end

  it 'renders new hosting_environment form' do
    render

    assert_select 'form[action=?][method=?]', hosting_environments_path, 'post' do
      assert_select 'input[name=?]', 'hosting_environment[title]'

      assert_select 'input[name=?]', 'hosting_environment[description]'
    end
  end
end
