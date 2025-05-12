# frozen_string_literal: true

set :rails_env, :production
set :branch, 'integration/uc_sso'
set :bundle_without, %w[development test].join(' ')
set :default_env, path: '$PATH:/usr/local/bin'
set :bundle_path, -> { shared_path.join('vendor/bundle') }
append :linked_dirs, 'tmp', 'log'
server 'libappstest.libraries.uc.edu',
       user: 'apache', # or whatever user owns the app
       roles: %i[web app db],
       port: 22
set :deploy_to, '/opt/webapps/application_portfolio'

# Optional: forward SSH agent if using deploy keys from your local machine
set :ssh_options, forward_agent: true

after 'deploy:updating', 'ruby_update_check'
after 'deploy:updating', 'init_qp'
before 'deploy:cleanup', 'start_qp'

