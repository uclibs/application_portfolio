# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'change_requests/show.html.erb', type: :view do
  let(:change_request) { FactoryBot.create(:change_request) }
  before(:each) do
    assign(:change_request, change_request)
    admin = FactoryBot.create(:admin)
    sign_in(admin)
    render
  end
end
