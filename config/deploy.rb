# frozen_string_literal: true

require 'byebug'

# config valid for current version and patch releases of Capistrano
lock '~> 3.20.1'

set :application, 'application_portfolio'
set :repo_url, 'https://github.com/uclibs/application_portfolio.git'

# Written by capistrano-bundler 2.x during `bundler:config`, before `bundle install`.
# deployment: frozen Gemfile.lock, no dev/test groups on the server.
# force_ruby_platform: lockfile includes platform-specific native gems (nokogiri,
# sqlite3, ffi) from Mac dev machines and CI; Linux deploy hosts must install
# the generic ruby-platform gems and compile on the server (see LIBAPPO1-80).
set :bundle_config, { deployment: true, force_ruby_platform: true }

task :shared_db do
  on roles(:all) do
    execute "mkdir -p #{fetch(:deploy_to)}/shared/db/ && touch #{fetch(:deploy_to)}/shared/db/development.sqlite3"
    execute "mkdir -p #{fetch(:deploy_to)}/static"
    execute "cp #{fetch(:deploy_to)}/static/.env.development #{fetch(:release_path)}/ || true"
  end
end

task :start_local do
  on roles(:all) do
    execute "export PATH=$PATH:/usr/local/bin && cd #{fetch(:deploy_to)}/current/scripts && source start_local.sh"
    execute "mkdir -p #{fetch(:deploy_to)}/static"
  end
end

# Runs on QA and production after deploy:updating, before bundler:config/install.
# Bundle path, groups, deployment, and force_ruby_platform are handled by
# capistrano-bundler (see :bundle_config above).
task :init_qp do
  on roles(:all) do
    # Must run before capistrano-bundler's bundler:install on hosts without a current Bundler.
    execute 'gem install --user-install bundler'
    execute "mkdir -p #{fetch(:deploy_to)}/static"
    execute "cp #{fetch(:deploy_to)}/static/.env.production #{fetch(:release_path)}/ || true"
  end
end

task :start_qp do
  on roles(:all) do
    execute "cd #{fetch(:release_path)}/ && chmod a+x scripts/* && source scripts/start_qp.sh"
  end
end

# Ensures the Ruby version in .ruby-version is installed via rbenv on QA/production.
# Deploy hosts use rbenv under the apache user (/home/apache/.rbenv); see README.
task :ruby_update_check do
  on roles(:all) do
    execute "cd #{fetch(:release_path)}/ && chmod a+x scripts/* && source scripts/check_ruby.sh"
  end
end

namespace :deploy do
  task :confirmation do
    stage = fetch(:stage).upcase
    branch = fetch(:branch)
    puts <<-WARN

    ========================================================================

      *** Deploying to branch `#{branch}` to #{stage} server ***

      WARNING: You're about to perform actions on #{stage} server(s)
      Please confirm that all your intentions are kind and friendly

    ========================================================================

    WARN
    ask :value, "Sure you want to continue deploying `#{branch}` on #{stage}? (Y)"

    if fetch(:value).to_s.downcase != 'y'
      puts "\nDeploy cancelled!"
      exit
    end
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'deploy:confirmation'
end

after 'deploy:publishing', 'db:migrate'
# assets:precompile sources scripts/check_node.sh (nvm + yarn) then runs dartsass:build and
# javascript:build (yarn install + yarn build) before fingerprinting assets.
after 'deploy:publishing', 'assets:precompile'
