#!/usr/bin/env bash
# Run on deploy via Capistrano (execute :bash, 'scripts/assets_precompile.sh') so SSHKit
# applies within release_path and RAILS_ENV. Sources check_node.sh then precompiles assets.
set -euo pipefail

APP_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$APP_ROOT"

[ -f Gemfile ] || { echo "Not in application root: ${APP_ROOT}" >&2; exit 1; }

source scripts/check_node.sh
exec bundle exec rails assets:precompile
