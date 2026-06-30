#!/usr/bin/env bash
set -euo pipefail

bundle exec rails db:prepare RAILS_ENV=test
