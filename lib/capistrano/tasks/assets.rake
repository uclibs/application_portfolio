# frozen_string_literal: true

namespace :assets do
  desc 'Compile dartsass + esbuild outputs and fingerprint assets for production'
  task :precompile do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :chmod, 'a+x', 'scripts/check_node.sh'
          execute :bash, '-lc', 'source scripts/check_node.sh && bundle exec rails assets:precompile'
        end
      end
    end
  end
end
