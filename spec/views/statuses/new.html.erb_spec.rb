# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'statuses/new', type: :view do
  before(:each) do
    assign(:status, Status.new(
                      title: 'Test',
                      status_type: 'Design'
                    ))
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:admin) })
  end

  it 'renders new status form' do
    render

    assert_select 'form[action=?][method=?]', statuses_path, 'post' do
      assert_select 'input[name=?]', 'status[title]'

      assert_select 'select[name=?]', 'status[status_type]'
    end
  end
end
