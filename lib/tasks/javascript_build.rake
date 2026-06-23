# frozen_string_literal: true

namespace :javascript do
  task prepare_node_path: :environment do
    JavascriptBuildEnv.apply!
  end
end

%w[javascript:install javascript:build].each do |name|
  Rake::Task[name].enhance(['javascript:prepare_node_path'])
end
