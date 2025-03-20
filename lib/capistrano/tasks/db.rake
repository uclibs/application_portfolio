# frozen_string_literal: true

namespace :db do
  desc 'Run the migrations'
  task :migrate do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rails db:migrate'
        end
      end
    end
  end
end
