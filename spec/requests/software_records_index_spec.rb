# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Software records index filters', type: :request do
  let(:admin) { FactoryBot.create(:admin) }

  before { sign_in admin }

  it 'renders filter UI wired to filter-management Stimulus controller' do
    get software_records_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('data-controller="filter-management"')
    expect(response.body).to include('data-action="change->filter-management#togglePanels"')
    expect(response.body).to include('data-filter-management-target="vendorFilter"')
    expect(response.body).to include('data-filter-management-target="softwareTypeFilter"')
    expect(response.body).to include('data-action="click->filter-management#clearAndRedirect"')
  end

  it 'shows the vendor filter panel when filtering by vendor records' do
    vendor = FactoryBot.create(:vendor_record)

    get software_records_path, params: { filter_by: 'vendor_records', vendor_record_filter: vendor.id }

    expect(response).to have_http_status(:ok)
    expect(response.body).to match(/id="vendor-record-filter"[^>]*style="display:\s*block;?"/)
    expect(response.body).to match(/id="software-type-filter"[^>]*style="display:\s*none"/)
  end

  it 'shows the software type filter panel when filtering by software types' do
    software_type = FactoryBot.create(:software_type)

    get software_records_path, params: { filter_by: 'software_types', software_type_filter: software_type.id }

    expect(response).to have_http_status(:ok)
    expect(response.body).to match(/id="software-type-filter"[^>]*style="display:\s*block;?"/)
    expect(response.body).to match(/id="vendor-record-filter"[^>]*style="display:\s*none"/)
  end
end
