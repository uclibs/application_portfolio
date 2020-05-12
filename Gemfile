# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Devise for authentication
gem 'devise'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use rails-controller-testing for testing a controller
gem 'rails-controller-testing'
# Use coveralls for code-coverage
gem 'coveralls', require: false
# Use rubocop for static code analysis
gem 'rubocop'
# Use simplecov to generate the coveralls report in .html format
gem 'simplecov', require: false
# Use bootstrap css, jquery-rails gem for styling the components
gem 'bootstrap', '~> 4.3.1'
gem 'jquery-rails'
# Use dotenv gem to store the environment variables
gem 'dotenv-rails'
# Use petergate for authorization
gem 'petergate'
# Use gritter for flash message
gem 'gritter'
# Use bootstrap-datepicker-rails for datepicker
gem 'bootstrap-datepicker-rails'
# Use chartkick for data-visualization
gem 'chartkick'
# Use groupdate to group by dates
gem 'csv'
gem 'groupdate'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capisrtrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop
  # execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Use factory_bot_rails to generate random test data
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~>3.8'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  # Mysql database.
  gem 'mysql2'
  # Needed to get console working in production mode
  gem 'rb-readline'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
