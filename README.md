[![Coverage Status](https://coveralls.io/repos/github/uclibs/application_portfolio/badge.svg?branch=qa)](https://coveralls.io/github/uclibs/application_portfolio?branch=qa)

# Application Portfolio

This is a web application developed for the management of UC Libraries application profile.  
This application tracks, monitors, and secures information on all of UCL's services, software, and support.

### Quick start

```bash
git clone git@github.com:uclibs/application_portfolio.git
cd application_portfolio
nvm install    # Node 24.x per .nvmrc
nvm use
corepack enable   # once per machine; activates Yarn 4 from package.json
bin/setup      # bundle, yarn install, JS/CSS builds, db:setup
bin/dev        # Rails + esbuild watch + dartsass watch (recommended)
```

Or run the server only after setup: `bin/rails server`.

Use Ruby **3.4.9** (see `.ruby-version`), **Rails 8.1**, **Node.js 24.x** (see `.nvmrc`), and **Yarn 4.x** (see `packageManager` in `package.json`). Local developers may use **RVM or rbenv**; deploy hosts use rbenv (see Deployment below).

After pulling changes: `bin/update` (bundle, `yarn install`, rebuild assets, migrate). Run `corepack enable` once if `yarn` is not found.

## System dependencies

| Requirement | Version / notes |
|-------------|-----------------|
| Ruby | 3.4.9 (`.ruby-version`) |
| Rails | 8.1 |
| Node.js | 24.x (`.nvmrc`; `nvm install` in project root) |
| Yarn | 4.x via Corepack (`packageManager` in `package.json`; `nodeLinker: node-modules` in `.yarnrc.yml`) |

Do **not** install Yarn Classic globally. Node 24 includes Corepack; run `corepack enable` once, then `bin/yarn` (or `yarn`) uses the version pinned in `package.json`. CI and deploy use `yarn install --immutable` (Yarn 4’s equivalent of `--frozen-lockfile`).

## Asset pipeline

Front-end assets use a **compile-then-serve** model (dartsass + esbuild → `app/assets/builds/`, Propshaft → `public/assets/`).

```
SCSS (app/assets/stylesheets/)  →  dartsass:build  →  app/assets/builds/*.css
JS   (app/javascript/)          →  javascript:build →  app/assets/builds/application.js
builds/ + images/               →  assets:precompile →  public/assets/ (+ .manifest.json)
```

**Propshaft** serves digest-stamped files from `public/assets/`. Layouts still use `stylesheet_link_tag` and `javascript_include_tag`; Propshaft resolves logical names (`application.css`, `application.js`) via the manifest. Source SCSS under `app/assets/stylesheets/` is excluded from Propshaft load paths (only compiled CSS in `builds/` is published).

Navigation uses **Hotwire Turbo** (`@hotwired/turbo-rails` in the esbuild bundle). Custom UI behaviors use **Stimulus** controllers under `app/javascript/controllers/` (register new controllers in `controllers/index.js`). Flash toasts use the `flash-toast` Stimulus controller, not gritter.

**Committed vs generated builds:** `app/assets/builds/application.js` (and `.map` / `.sources.sha256`) are committed so CI can verify the bundle matches sources. Compiled CSS (`application.css`, `software_records.css`) is **gitignored** — run `bin/rails dartsass:build` locally (or use `bin/setup` / `bin/dev`).

### Local commands

First-time setup (after `corepack enable`):

```bash
nvm use
bin/setup                    # bundle, yarn install, JS/CSS builds, db:setup
```

Day-to-day and manual asset commands:

```bash
nvm use
bin/update                   # after pull: bundle, yarn install, rebuild assets, migrate
bin/dev                      # Foreman: Rails + esbuild watch + dartsass watch
bin/yarn install             # or: bin/yarn install --immutable (CI-style)
bin/yarn build               # same as bin/rails javascript:build
bin/rails dartsass:build
bin/rails assets:precompile  # JS + CSS builds + Propshaft digest (dev/production)
```

After changing JS dependencies or source files, commit `package.json`, `.yarnrc.yml`, `yarn.lock`, and `app/assets/builds/application.js` (+ `.map` and `.sources.sha256` when present). Run `bin/yarn install` after pulling dependency changes.

The **test** environment sets `SKIP_JS_BUILD` (`config/application.rb`); `assets:precompile` runs `dartsass:build` only and uses the committed JS bundle.

### Deploy expectations

QA and production both use `RAILS_ENV=production` on deploy hosts. Capistrano’s `deploy:assets:precompile` (during `deploy:updated`) runs `scripts/assets_precompile.sh`:

1. Source `scripts/check_node.sh` (nvm + `.nvmrc`, Yarn 4 via Corepack from `packageManager`)
2. `bundle exec rails assets:precompile` — `javascript:build`, `dartsass:build`, then Propshaft copies digested assets to `public/assets/`

Production sets far-future `cache-control` headers for static files (`max-age=1.year`) because filenames include content hashes.

**CI:** `corepack enable`, `yarn install --immutable`, `yarn build`, and `bundle exec rails dartsass:build` run before RSpec (CircleCI and GitHub Actions).

### Bootstrap (npm + vendored assets)

Bootstrap **5.x** is installed from npm (`package.json`). Dart Sass compiles the committed vendor SCSS under `app/assets/stylesheets/vendor/bootstrap/scss/`. JavaScript comes from the esbuild bundle (`import` from `node_modules` at build time).

Deploy hosts do not run `yarn` for Bootstrap SCSS vendoring (use `bootstrap:vendor` locally). After upgrading Bootstrap in `package.json`, refresh vendor SCSS and rebuild JS locally:

```bash
nvm use
corepack enable
bin/yarn install
bundle exec rake bootstrap:vendor
bin/yarn build
bin/rails dartsass:build
```

Commit `package.json`, `.yarnrc.yml`, `yarn.lock`, `app/assets/builds/application.js`, and the updated files under `app/assets/stylesheets/vendor/bootstrap/`.

## Running the Tests

The test suite uses RSpec, RuboCop, and Coveralls. From the project root:

```bash
nvm use
corepack enable   # Yarn 4; required if node_modules is missing
bundle exec rspec
bundle exec rubocop
```

The test environment is configured to **raise on Rails/Rack deprecations** (`config.active_support.deprecation = :raise`), so deprecation warnings fail the suite rather than printing to stderr.

For Coveralls locally:

```bash
coveralls report
```

## Database

`bin/setup` runs `db:setup` (create, schema load, seed). To migrate only:

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
| QA / production | libappstest, libapps | **nvm** (user `apache`) | `scripts/assets_precompile.sh` sources `check_node.sh` (Node from `.nvmrc`, Yarn 4 via Corepack) during `deploy:assets:precompile` |
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

Dashboard charts use the **chartkick** gem (Ruby helpers) with **Chart.js** and **chartkick** npm packages bundled via esbuild (`app/javascript/application.js`).
