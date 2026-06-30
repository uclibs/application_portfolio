#!/usr/bin/env bash
# Shared Corepack/Yarn 4 helpers. Source from CI and deploy scripts:
#   source "${repo_root}/scripts/corepack_yarn.sh"
#   setup_corepack_yarn
#   run_yarn install
# Or run directly: bash scripts/corepack_yarn.sh

yarn_version_from_package_json() {
  node -p "require('./package.json').packageManager.replace(/^yarn@/, '').split('+')[0]"
}

_corepack_node_bin() {
  node -p 'require("path").dirname(process.execPath)'
}

run_corepack() {
  local node_bin corepack_js
  node_bin="$(_corepack_node_bin)"

  if [[ -x "${node_bin}/corepack" ]]; then
    "${node_bin}/corepack" "$@"
    return $?
  fi

  corepack_js="${node_bin}/../lib/node_modules/corepack/dist/corepack.js"
  if [[ -f "${corepack_js}" ]]; then
    node "${corepack_js}" "$@"
    return $?
  fi

  if command -v corepack >/dev/null 2>&1; then
    corepack "$@"
    return $?
  fi

  echo "Corepack not found next to Node at ${node_bin}; installing via npm" >&2
  local npm_prefix="${HOME}/.npm-global"
  mkdir -p "${npm_prefix}/bin"
  export PATH="${npm_prefix}/bin:${PATH}"
  npm install -g corepack --prefix "${npm_prefix}"
  "${npm_prefix}/bin/corepack" "$@"
}

run_corepack_enable() {
  local node_bin install_dir
  node_bin="$(_corepack_node_bin)"
  install_dir="${HOME}/bin"
  mkdir -p "${install_dir}"
  export PATH="${node_bin}:${install_dir}:${PATH}"

  if run_corepack enable --install-directory "${install_dir}" 2>/dev/null; then
    return 0
  fi

  run_corepack enable
}

setup_corepack_yarn() {
  local yarn_version active_yarn_version package_manager

  yarn_version="$(yarn_version_from_package_json)"
  if [[ -z "${yarn_version}" ]]; then
    echo "Could not read yarn version from package.json packageManager field." >&2
    return 1
  fi

  package_manager="$(node -p "require('./package.json').packageManager")"
  run_corepack_enable
  run_corepack prepare "${package_manager}" --activate

  active_yarn_version="$(run_yarn --version 2>/dev/null || true)"
  if [[ ! "${active_yarn_version}" =~ ^4\. ]]; then
    echo "Expected Yarn 4.x after Corepack setup, got: ${active_yarn_version:-none}" >&2
    return 1
  fi
}

run_yarn() {
  run_corepack yarn "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  set -euo pipefail
  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  cd "${repo_root}"
  setup_corepack_yarn
fi
