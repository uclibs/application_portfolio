# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'file_uploads/new.html.erb', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           FactoryBot.build(:admin)
                                                                         end)
    @file = assign(:file_upload, FileUpload.new(attachment: 'Test file.csv'))
  end
  it 'renders the file_uploads form' do
    render
    assert_select 'form[action=?][method=?]', file_uploads_path, 'post' do
      assert_select 'input[id=?]', 'seed_srecords'
      assert_select 'input[id=?]', 'seed_vrecords'
      assert_select 'input[id=?]', 'seed_stypes'
      assert_select 'input[name=?]', 'file_upload[attachment]'
    end
  end
end
