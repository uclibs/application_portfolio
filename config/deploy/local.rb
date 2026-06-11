# frozen_string_literal: true

# Local Capistrano deploy to localhost (development SQLite, no init_qp).

set :rails_env, :development
# Colon-separated groups; required by capistrano-bundler 2.x / Bundler 2.
set :bundle_without, %w[production test].join(':')
set :branch, 'qa'
set :default_env, path: '$PATH:/usr/local/bin'
append :linked_files, 'db/development.sqlite3'
append :linked_dirs, 'tmp', 'log', 'public/system'
ask(:username, nil)
ask(:password, nil, echo: false)
server 'localhost', user: fetch(:username), password: fetch(:password), port: 22,
                    roles: %i[web app db]
set :deploy_to, '~/application_portfolio'
before 'deploy:starting', 'shared_db'
before 'deploy:cleanup', 'start_local'
