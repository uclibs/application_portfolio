# frozen_string_literal: true

# capistrano-rails runs deploy:assets:precompile during deploy:updated. Override it so
# nvm Node from .nvmrc is on PATH before javascript:install (yarn checks engines.node).
Rake::Task['deploy:assets:precompile'].clear_actions

namespace :deploy do
  namespace :assets do
    desc 'Compile dartsass + esbuild outputs and fingerprint assets for production'
    task :precompile do
      on release_roles(fetch(:assets_roles)) do
        within release_path do
          with rails_env: fetch(:rails_env), rails_groups: fetch(:rails_assets_groups) do
            # Array-form execute so SSHKit applies within release_path and RAILS_ENV.
            execute :bash, 'scripts/assets_precompile.sh'
          end
        end
      end
    end
  end
end
