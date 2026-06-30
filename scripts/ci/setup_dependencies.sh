#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "${repo_root}"

"${repo_root}/scripts/ci/setup_ruby_dependencies.sh"

# shellcheck source=scripts/corepack_yarn.sh
source "${repo_root}/scripts/corepack_yarn.sh"
setup_corepack_yarn

run_yarn install --immutable
