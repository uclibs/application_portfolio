# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.11.2'

set :application, 'application_portfolio'
set :repo_url, 'https://github.com/uclibs/application_portfolio.git'

task :shared_db do
  on roles(:all) do
    execute "mkdir -p #{fetch(:deploy_to)}/shared/db/ && touch #{fetch(:deploy_to)}/shared/db/development.sqlite3"
    execute "mkdir -p #{fetch(:deploy_to)}/static"
    execute "cp #{fetch(:deploy_to)}/static/.env.development #{fetch(:release_path)}/ || true"
  end
end

task :start_local do
  on roles(:all) do
    execute "export PATH=$PATH:/usr/local/bin && cd #{fetch(:deploy_to)}/current/script && source start_local.sh"
    execute "mkdir -p #{fetch(:deploy_to)}/static"
  end
end

task :start_curly do
  on roles(:all) do
    execute "export PATH=$PATH:/usr/sbin/ && cd #{fetch(:deploy_to)}/current/script && chmod u+x * && source start_curly.sh"
    execute "mkdir -p #{fetch(:deploy_to)}/static"
  end
end

task :init_qp do
  on roles(:all) do
    execute 'gem install --user-install bundler'
    execute "mkdir -p #{fetch(:deploy_to)}/static"
    execute "cp #{fetch(:deploy_to)}/static/.env.production #{fetch(:release_path)}/ || true"
  end
end

task :start_qp do
  on roles(:all) do
    execute "cd #{fetch(:deploy_to)}/current && chmod a+x script/* && source script/start_qp.sh"
  end
end
