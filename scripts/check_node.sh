#!/usr/bin/env bash
# QA and production deploy hosts use nvm (user apache). Sourced from
# scripts/assets_precompile.sh on deploy. Installs Node from .nvmrc when missing.
set -euo pipefail

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "Source this script: source scripts/check_node.sh" >&2
  exit 1
fi

die() {
  echo "$1" >&2
  return 1
}

if [ ! -s .nvmrc ]; then
  die ".nvmrc missing or empty; run from the application root"
fi

read -r NODE_VERSION_RAW < .nvmrc
NODE_VERSION=${NODE_VERSION_RAW#v}
NODE_VERSION=${NODE_VERSION//$'\r'/}
NODE_VERSION=${NODE_VERSION//$'\n'/}

if [ -z "$NODE_VERSION" ]; then
  die ".nvmrc does not contain a Node version"
fi

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  die "nvm not found at $NVM_DIR/nvm.sh; install Node ${NODE_VERSION} before deploying"
fi

# shellcheck source=/dev/null
. "$NVM_DIR/nvm.sh"

if ! nvm which "$NODE_VERSION" >/dev/null 2>&1; then
  nvm install "$NODE_VERSION" --no-progress
fi

nvm use "$NODE_VERSION" >/dev/null
NODE_BIN="$(dirname "$(nvm which "$NODE_VERSION")")"
export PATH="${NODE_BIN}:${PATH}"

ACTIVE_NODE="$(node -p "process.versions.node")"
if [[ "$ACTIVE_NODE" != "$NODE_VERSION"* ]]; then
  die "Active Node ${ACTIVE_NODE} does not match .nvmrc (${NODE_VERSION})"
fi

if command -v corepack >/dev/null 2>&1; then
  corepack enable
  if [ -f package.json ]; then
    PACKAGE_MANAGER="$(node -p "require('./package.json').packageManager" 2>/dev/null || true)"
    if [ -n "$PACKAGE_MANAGER" ]; then
      corepack prepare "$PACKAGE_MANAGER" --activate
    fi
  fi
fi

if ! command -v yarn >/dev/null 2>&1; then
  die "yarn not found after activating Node ${NODE_VERSION}; enable corepack on deploy hosts"
fi
