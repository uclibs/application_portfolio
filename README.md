[![Coverage Status](https://coveralls.io/repos/github/uclibs/application_portfolio/badge.svg?branch=qa)](https://coveralls.io/github/uclibs/application_portfolio?branch=qa)

# Application Portfolio

This is a web application developed for the management of UC Libraries application profile.  
This application tracks, monitors, and secures information on all of UCL's services, software, and support.  
Provided that you have Ruby on Rails installed you can run this application on your local machine or server.

```bash
git clone git@github.com:uclibs/application_portfolio.git
cd application_portfolio
bundle install
bin/rails db:migrate
bin/rails server
```

Use Ruby **3.4.9** (see `.ruby-version`). Local developers may use **RVM or rbenv**; deploy hosts use rbenv (see Deployment below).

## Ruby version and System dependencies

Ruby 3.4.9

Node.js 24.x (see `.nvmrc`; run `nvm install` in the project root)

### JavaScript (esbuild)

JavaScript is bundled with **esbuild** via `jsbundling-rails` (LIBAPPO1-101, LIBAPPO1-108). The entry point is `app/javascript/application.js`; `bin/rails javascript:build` (or `bin/yarn build`) writes `app/assets/builds/application.js` and source maps. Layouts load that bundle as a single deferred ES module (Turbo, Bootstrap, Chartkick, Active Storage, and app scripts).

`app/assets/builds/application.js` is **committed** so CI can verify the bundle matches sources (`yarn build` + git diff in CircleCI and GitHub Actions). The **test** environment skips esbuild during `assets:precompile` (`SKIP_JS_BUILD` in `config/application.rb`); **production deploy** runs `yarn install`, `yarn build`, and `dartsass:build` before Sprockets precompile.

After changing JS dependencies or source files locally:

```bash
nvm use
yarn install
bin/rails javascript:build
```

Commit `package.json`, `yarn.lock`, and `app/assets/builds/application.js` (+ `.map` and `.sources.sha256` when present). Run `yarn install` locally after pulling dependency changes.

For local development with live rebuilds, use Foreman (runs Rails, esbuild watch, and Dart Sass watch). Run `nvm use` first so `bin/yarn` resolves Node 24:

```bash
nvm use
bin/dev
```

**CI:** `yarn install --frozen-lockfile`, `yarn build`, and `bundle exec rails dartsass:build` run before RSpec.

**Deploy:** Capistrano’s `deploy:assets:precompile` (during `deploy:updated`) sources `scripts/check_node.sh` (nvm + `.nvmrc`, yarn via corepack when needed) in the same shell as `bundle exec rails assets:precompile`, which runs `javascript:build` (yarn) and `dartsass:build` before fingerprinting assets.

### Bootstrap (npm + vendored assets)

Bootstrap **5.x** is installed from npm (`package.json`). Dart Sass compiles the committed vendor SCSS under `app/assets/stylesheets/vendor/bootstrap/scss/`. JavaScript comes from the esbuild bundle (`import` from `node_modules` at build time).

Deploy hosts do not run `yarn` for Bootstrap SCSS vendoring (use `bootstrap:vendor` locally). JavaScript is rebuilt on deploy via `assets:precompile`. After upgrading Bootstrap in `package.json`, refresh vendor SCSS and rebuild JS locally:

```bash
nvm use
yarn install
bundle exec rake bootstrap:vendor
bin/rails javascript:build
```

Commit `package.json`, `yarn.lock`, `app/assets/builds/application.js`, and the updated files under `app/assets/stylesheets/vendor/bootstrap/`.

## Running the Tests

The test suite uses RSpec, RuboCop, and Coveralls. From the project root:

```bash
nvm use   # Node 24.x; required for yarn install if node_modules is missing
bundle exec rspec
bundle exec rubocop
```

The test environment is configured to **raise on Rails/Rack deprecations** (`config.active_support.deprecation = :raise`), so deprecation warnings fail the suite rather than printing to stderr.

For Coveralls locally:

```bash
coveralls report
```

## Database creation

```bash
bin/rails db:migrate RAILS_ENV=development
```

## Developer Guide

* Create Admin Account
```bash
rails console

email_address = "user@example.com"

user = User.find_by(email: email_address)

user.roles = "root_admin"

user.save

```
* Deployment instructions

We deploy this application to both qa and production using Capistrano. You must be on the library intranet to deploy from your local workstation.

```bash
cap qa deploy          # QA (libappstest)
cap production deploy  # production (libapps)
```

**Ruby version managers on deploy hosts**

| Environment | Host | Ruby manager | Notes |
|-------------|------|--------------|-------|
| QA / production | libappstest, libapps | **rbenv** (user `apache`, `/home/apache/.rbenv`) | `scripts/check_ruby.sh` runs on deploy to install the version from `.ruby-version` when missing |
| QA / production | libappstest, libapps | **nvm** (user `apache`) | `scripts/check_node.sh` is sourced during `deploy:assets:precompile` to install Node from `.nvmrc` when missing |
| Local cap deploy | localhost | **RVM** (via `scripts/start_local.sh` only) | Optional dev workflow; Capistrano does not use the capistrano-rvm gem |

Puma on QA/production is managed by systemd (`puma-appport.service`), not by Capistrano's Ruby plugin.

* Configuration

## Shibboleth SSO

- **Routes:** SSO callback `/auth/shibboleth`; local Devise `/users/sign_in` (email-only, no password) when enabled.
- **Environments:** Production uses SSO (`config.x.auth.shibboleth_enabled`). Local email sign-in is gated by `config.x.auth.allow_email_sign_in` (on in development/test, off in production — see `config/environments/*.rb`).
- **Headers:** Rails trusts canonical Shibboleth headers only (`HTTP_EPPN`, `HTTP_MAIL`, `HTTP_GIVENNAME`, `HTTP_SN`, mapping SAML `eppn`, `mail`, `givenName`, `sn`). Enable `config.x.auth.allow_legacy_shibboleth_env_keys` only if Apache delivers `REDIRECT_HTTP_*` or other legacy env shapes and you need a temporary rollback.
- **Provisioning:** Primary match on `eppn`; existing users may link by `email` when `eppn` was never set. Missing/null-like values fall back to deterministic `firstname.lastname@uc.edu` (with placeholder names when needed). First-time SSO users are active `viewer`s.
- **Ops:** Protect the SSO route with mod_shib; identity must come from the server/IdP path, not the browser alone.
- **Error page:** Validation messages from failed account creation are not shown to users in production (they are logged). Turn on `config.x.auth.expose_shibboleth_validation_errors` only when you need on-screen details for debugging.

* Type of Roles

There are 4 types of roles in the Application Portfolio.

Admin (App Portfolio Tech Lead)
Manager (IT Staff and App Dev Staff)
Owner (CTO, Department Heads, AD)
Viewer (Library Faculty and Staff)

A complete defintion of each role can be found here https://github.com/uclibs/application_portfolio/wiki/Roles-in-Application-Portfolio

* Import/Export Documentation.

This application uses both db:seed to populate that application with Software Types, Vendor Records, and Application Records.  This is important because Vendor Records and Software Types are look up fields and the application is unable to create new records without some values in these database fields.

There is also a direct upload tool built into the Admin Menu Options.  This tool will take a .csv file and import the Software Types, Vendor Records, and Application Records.  This tool has a de-duping tool built into the load records and will not overwrite records in the database..

* Master Key

Uses the rails MessageEncryptor to encrypt and decrypt the data.
Added utility functions(helpers) that encrypt and decrypt based on rails key.
Re-generated master key to be consistent with MessageEncryptor.
Automatic encryption and decryption on UI. But only encrypted on DB.

* Graphs

We use the chartkick gem to draw our graphs
