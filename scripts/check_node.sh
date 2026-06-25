#!/bin/bash
# QA and production deploy hosts use nvm (user apache). Sourced during cap deploy
# assets:precompile (see lib/capistrano/tasks/assets.rake) so nvm PATH persists
# for yarn/esbuild. Installs the version from .nvmrc when missing.
set -euo pipefail

_sourced=0
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  _sourced=1
fi

_fail() {
  echo "$1" >&2
  if [[ $_sourced -eq 1 ]]; then
    return 1
  fi
  exit 1
}

NODE_VERSION=$(tr -d 'v' < .nvmrc)
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  _fail "nvm not found at $NVM_DIR/nvm.sh; install Node ${NODE_VERSION} before deploying"
fi

# shellcheck source=/dev/null
. "$NVM_DIR/nvm.sh"

if ! nvm which "$NODE_VERSION" >/dev/null 2>&1; then
  nvm install "$NODE_VERSION" --no-progress
fi

nvm use "$NODE_VERSION"
NODE_BIN="$(dirname "$(nvm which "$NODE_VERSION")")"
export PATH="${NODE_BIN}:${PATH}"

if ! command -v yarn >/dev/null 2>&1; then
  if command -v corepack >/dev/null 2>&1; then
    corepack enable
  fi
fi

if ! command -v yarn >/dev/null 2>&1; then
  _fail "yarn not found after activating Node ${NODE_VERSION}; install yarn or enable corepack on deploy hosts"
fi

if [[ $_sourced -eq 0 ]]; then
  node -v
  yarn -v
fi
