# frozen_string_literal: true

namespace :assets do
  desc 'Run assets precompile'
  task :precompile do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rails assets:precompile'
        end
      end
    end
  end
end
