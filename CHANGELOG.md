# Changelog

Release versions match git tags (for example, `v3.0.0`).

3.1.0 (unreleased)

* Upgrades Ruby to 4.0.5; adds `cgi` gem (stdlib removed in Ruby 4)
* Upgrades Node to 26.4.0 (org standard); CI and deploy scripts unchanged in behavior
* Rails remains on 8.1.3 (latest 8.1.x)

3.0.0 6/25/2026

* Modernizes the frontend and asset pipeline (major operational change for deploys)
  * Replaces Sprockets with Propshaft
  * Replaces sassc-rails with dartsass-rails; migrates app SCSS from `@import` to `@use`
  * Adds esbuild and jsbundling-rails; builds JavaScript during `assets:precompile` (bundle no longer committed to git)
  * Migrates Turbolinks to Turbo and replaces Rails UJS with Turbo
  * Introduces Stimulus controllers for navigation, filters, tabs, flash toasts, multi-value inputs, and input sanitization
  * Removes jquery-rails and legacy CoffeeScript / Sprockets JavaScript
  * Replaces gritter flash plugin with Stimulus-driven flash toasts
  * Vendors Bootstrap 5 from npm (removes bootstrap gem); consolidates dashboard SCSS into shared partials
  * Replaces bootstrap-datepicker with native HTML date inputs
  * Upgrades Yarn 1.22 to Yarn 4 (Corepack)
  * Wires Node 24 and asset builds into CI and Capistrano deploy (`check_node.sh`, full `assets:precompile`)
  * Removes vestigial Sprockets configuration and unused asset dependencies
* Deployment and platform updates
  * Capistrano uses rbenv on servers; upgrades capistrano-bundler to 2.x; drops capistrano-rvm
  * Audits and resolves Rails 8 / Rack 3 deprecations (`:unprocessable_content`)
  * Refreshes Ruby and JavaScript dependencies; documents bundler-audit suppressions
  * Optimizes RSpec suite asset builds (skip rebuild when sources unchanged)
  * Removes shoulda-matchers in favor of behavioral model specs
* Bug Fixes
  * Fixes dashboard button sizing

2.0.0 5/29/2026

* Implements Single Sign-On (SSO) via Shibboleth
  * Adds Shibboleth session handling and user provisioning
  * Adds EPPN field to users
  * Removes local Devise registration, password reset, and signup mailer
* Upgrades Rails to 8.1.3
* Upgrades Rack to 3.2
* Updates Ruby to 3.4.9
* Updates Nokogiri to 1.19
* Updates Node to 24
* Updates Capistrano and Selenium dependencies
* Removes unused Docker development tooling
* Removes unused Application Cable boilerplate
* Creates dev users only in the development environment
* Bundle and yarn updates; adds bundler-audit to the GitHub workflow
* Bug Fixes
  * Fixes multi-value "add more" fields

1.7.1 2/13/2026

* Updates Ruby to 3.4.7
* CI: moves to ubuntu-22.04 and ruby/setup-ruby@v1 for Ruby 3.4.7
* Fixes .gitignore so `db/*.sqlite3*` files are ignored
* Removes obsolete Brakeman ignore (Rails 6.1.7.10 EOL)

1.7.0 10/20/2025

* Change Requestor Exporter
* Adds Roadmap Field to export
* Cleans up Bootstrap 5
* Change Text boxes to Text area
* Change Sememster to Planned
* Add Maintenance Field
* Add Plaaned Date
* Bug Fixes
  * Clear Filter
  * Fix tab navigation
  * Fixes accessibility errors with Javascript
* Changed Current Installation Field
* Adds Capistrano Tasks 
* Updates Ruby to 3.3.9
* Updates Rails to 7.2.2

1.6.0 3/5/2025
* Updates Rails to version 7.2.2.1
* Adds mutex_m and globalize gems.
* Removes spring.
* Bundle update

1.5.0 12/05/2024
* Updates Rails to version 6.1.7.10.
* Update to Bootstrap 5.
* Added drb gem.
* Bundle Update.

1.4.0 7/29/2024
* Updates Ruby to version 3.3.3.
* Updates Rails to version 6.1.7.8.
* Updates the deploy script to update ruby.
* Updates Github Actions.
* Bundle Update.
* Security updates to Nokogiri.
* Improves notes field with simple format.
* Moves javascript into asset pipeline.
* Adds Road Map feature.
* Adds Decommissioned as a feature.
* Bug Fixes
  * Fixes null value in export function.
  * Fixes sensitive information field.
  * Fixes problem of deleting a record with a change request associated.
  * Fixes problem with multi_value fields.

1.3.0 4/9/2024
* Updates Ruby to version 3.3.0
* Updates Rails to version 6.1.7.7
* Bug Fixes
  * Changes notes field to text.
  * Removes old server name.

1.2.0 8/18/2023
* Updates Ruby to version 3.2.2
* Updates Rails to version 6.1.7.4
* Updates Change Management and Upgrade Tab.
* Improves UX responsiveness for Change Request.
* Adds more required fields to ChangeRequest.
* Adds ChangeRequest Model.
* Use puma as a service
* Adds server and certificate fields to SoftwareRecords.
* Updates front and file_uploads controller to solve security vulnerabilities.
* Adds Maintentance Log and Priority list
* add local option to auth type
* Configure Github Actions and Coveralls
* Add Admin Roles to Software Records
* Updates linters and security gems
* Bug Fixes
  * Fixes edit_path on upgrade history.
  * Fixes rubocop errors in delete spec.
  * Fixes role access for manager and owner.
  * Fixes SoftwareRecords typos and test.
  * Fixes grey menu
  * Fixes some accessiblity issues.
  * Fixes password update.
  * Fix Software Graph
  * Update Secret Key call.

1.1.0 6/19/2021
* Cleaned up Status Field
* Removed status field from software records table
* Rubcop corrections
* Import Data script updated
* Dashboard edits
* Improved Coveralls Coverage
* Added Hosting Environment field
* Modified start up scripts for QA and Prod
* Bundle Update
* Setup tabs for software record
* Expanded db seeds
* Added Change Management fields
* Added Server Environment tab and fields
* Created yes/no toggle helper
* Added Authentication type field
* Added new field to import / export script
* Bug Fixes
  * Fixes blind sql injection
  * Updates chartkick gem

1.0.1 10/1/2020
* Prevent overwriting of data on import
* Left justify text on all index and dashboard
* Simplified buttons
* Updated login page description
* Modified http in url labels and fields
* Changed catalog display of url when empty
* Changed labels on product owner
* Fix footer accessibility issue
* Encrypted the sensitive information field
* Updated bottom graph to show total records
* Bug Fixes
  * Fixed support contract check box
  * Fixed problems with multi-valued field
  * Fixed navigation after editing record

1.0.0 7/17/2020
* Configured authentication
* Configured test environment
* Setup Bootstrap CSS
* Configured user abilities
* Dashboard and Catalog interfaces
* Configured User Management
* Menuing and Navigation
* Search
* Visualizations
* Data Export 
* Data Import
* Modelling for Software Records
* Modelling for Software Types
* Modelling for Software Vendors
* Secure Fields

0.1.0 1/16/2020

* Initial Rails application scaffold
* Configures Devise authentication
* Sets up RSpec, RuboCop, and Coveralls
* Early user-management work (pre-1.0 development milestone)
