# frozen_string_literal: true

namespace 'app_port' do
  desc 'Creates Decommissioned Status'
  task create_decom: :environment do
    # NOTE: In order to see progress in the logs, you must have logging at :info or above
    WorksResave.work_resave
    Status.new(title: 'Decommissioned', status_type: 'Decommissioned')
  end
end
