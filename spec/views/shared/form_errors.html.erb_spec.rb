# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'shared/form_errors', type: :view do
  let(:status) { Status.new(title: '', status_type: '') }

  it 'renders nothing when the object has no errors' do
    status.title = 'Valid'
    status.status_type = 'Design'
    status.validate

    render partial: 'shared/form_errors', locals: { object: status }

    expect(rendered).to be_blank
  end

  it 'renders Bootstrap danger alerts for each error message' do
    status.validate

    render partial: 'shared/form_errors', locals: { object: status }

    expect(rendered).to have_css('#error_explanation .alert.alert-danger', minimum: 1)
    expect(rendered).to include("Title can't be blank")
  end
end
