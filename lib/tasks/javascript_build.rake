# frozen_string_literal: true

namespace :javascript do
  task prepare_node_path: :environment do
    JavascriptBuildEnv.apply!
  end
end

# Prepare PATH before yarn install; javascript:build already depends on install.
Rake::Task['javascript:install'].enhance(['javascript:prepare_node_path']) if Rake::Task.task_defined?('javascript:install')
