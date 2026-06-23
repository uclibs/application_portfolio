# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExportDataController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    sign_in FactoryBot.create(:admin)
    allow(controller).to receive(:system)
    allow(controller).to receive(:`).and_return('')
    allow(controller).to receive(:send_file) { controller.head :ok }
  end

  %i[software_records vendor_records software_types change_requests].each do |export_action|
    describe "GET ##{export_action}" do
      it 'runs the export script and sends the CSV file' do
        get export_action

        expect(controller).to have_received(:`).with("ruby exports/#{export_action}.rb")
        expect(controller).to have_received(:send_file).with(
          "#{Dir.pwd}/public/#{export_action}.csv",
          disposition: 'attachment'
        )
        expect(response).to have_http_status(:success)
      end
    end
  end
end
