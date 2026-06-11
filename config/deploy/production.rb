# frozen_string_literal: true

# Production server (libapps.libraries.uc.edu)

set :rails_env, :production
# Colon-separated groups; required by capistrano-bundler 2.x / Bundler 2.
set :bundle_without, %w[development test].join(':')
set :branch, 'main'
set :default_env, path: '$PATH:/usr/local/bin'
# Shared across releases; written by capistrano-bundler's bundler:config.
set :bundle_path, -> { shared_path.join('vendor/bundle') }
append :linked_dirs, 'tmp', 'log'
ask(:username, nil)
ask(:password, nil, echo: false)
server 'libapps.libraries.uc.edu', user: fetch(:username), password: fetch(:password), port: 22
ask(:value, 'Have you submitted and received an approved Change Management Request? (Y)')
if fetch(:value) != 'Y'
  puts "\nDeploy cancelled!"
  exit
end
set :deploy_to, '/opt/webapps/application_portfolio'
# rbenv: ensure .ruby-version is installed before bundler:install (see check_ruby.sh).
after 'deploy:updating', 'ruby_update_check'
after 'deploy:updating', 'init_qp'
before 'deploy:cleanup', 'start_qp'
