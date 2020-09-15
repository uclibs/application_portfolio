# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'statuses/edit', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:admin) })
    @status = assign(:status, Status.create!(
                                title: 'Test',
                                status_type: 'Design'
                              ))
    params[:id] = 1
  end

  it 'renders the edit status form' do
    render

    assert_select 'form[action=?][method=?]', status_path(@status), 'post' do
      assert_select 'input[name=?]', 'status[title]'

      assert_select 'select[name=?]', 'status[status_type]'
    end
  end
end
