# frozen_string_literal: true

set :rails_env, :development
set :bundle_without, %w[production test].join(' ')
set :branch, 'qa'
set :default_env, path: '$PATH:/usr/sbin/'
append :linked_files, 'db/development.sqlite3'
append :linked_dirs, 'tmp', 'log', 'public/system'
ask(:username, nil)
ask(:password, nil, echo: false)
server 'curly.libraries.uc.edu', user: fetch(:username), password: fetch(:password), port: 22, roles: %i[web app db]
set :deploy_to, '/opt/rails-apps/application_portfolio'
before 'deploy:starting', 'shared_db'
before 'deploy:cleanup', 'start_curly'