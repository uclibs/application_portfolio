#!/usr/bin/env bash
# Run on deploy via Capistrano (execute :bash, 'scripts/assets_precompile.sh') so SSHKit
# applies within release_path and RAILS_ENV. Activates Node 26 (check_node.sh) and Yarn 4
# (corepack_yarn.sh) before assets:precompile builds JavaScript and CSS on the deploy host.
set -euo pipefail

APP_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$APP_ROOT"

[ -f Gemfile ] || { echo "Not in application root: ${APP_ROOT}" >&2; exit 1; }

source scripts/check_node.sh
# shellcheck source=scripts/corepack_yarn.sh
source scripts/corepack_yarn.sh
setup_corepack_yarn
exec bundle exec rails assets:precompile
