# frozen_string_literal: true

module SoftwareRecordsControllerSpecHelpers
  def self.included(base)
    base.class_eval do
      include Devise::Test::ControllerHelpers

      let(:valid_session) { {} }

      let(:valid_attributes) do
        {
          title: 'A Good Software',
          description: 'A Good description about the software',
          status_id: Status.first.id,
          software_type_id: SoftwareType.first.id,
          vendor_record_id: VendorRecord.first.id,
          created_by: 'Test Admin',
          developers: ['Random Admin'],
          tech_leads: ['Lead 1'],
          product_owners: %w[Owner1 Owner2],
          admin_users: %w[Admin1 Admin2],
          hosting_environment_id: HostingEnvironment.first.id,
          service: 'App Service',
          installed_version: '4.5',
          proposed_version: '4.4',
          last_upgrade_date: '2020-02-02',
          upgrade_available: true,
          vulnerabilities_reported: true,
          vulnerabilities_fixed: true,
          bug_fixes: true,
          new_features: true,
          breaking_changes: true,
          end_of_life: true,
          priority: '1',
          upgrade_status: 'Review',
          who: 'Test Admin',
          semester: 'Fall Quarter 2023',
          upgrade_docs: 'www.example.com',
          road_map: 'Road Map',
          qa_support_servers: 'server.example.com',
          dev_support_servers: 'dev.example.com',
          date_cert_expires: '2020-01-01',
          monitor_certificates: 'yes',
          themes: true,
          modules: true,
          maintenance_note: 'Maintain'
        }
      end

      let(:invalid_attributes) do
        {
          title: '',
          description: '',
          status_id: '',
          software_type_id: '',
          vendor_record_id: ''
        }
      end

      let(:decommissioned_attributes) do
        valid_attributes.merge(
          title: 'Decommissioned Software',
          status: Status.create!(title: 'Decommissioned', status_type: 'Decommissioned')
        )
      end

      before do
        sign_in FactoryBot.create(:admin)

        VendorRecord.create!(title: 'Vendor 1', description: 'test vendor')
        SoftwareType.create!(title: 'Web app', description: 'test software type')
        Status.create!(title: 'Test', status_type: 'Design')
        Status.create!(title: 'Production', status_type: 'Production')
        HostingEnvironment.create!(title: 'Test Env.', description: 'test env.')
      end
    end
  end
end
