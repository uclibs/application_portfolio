#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "${repo_root}"

expected_ruby="$(tr -d '[:space:]' < "${repo_root}/.ruby-version" | sed 's/^ruby-//')"
actual_ruby="$(ruby -e 'print RUBY_VERSION')"

if [[ "${actual_ruby}" != "${expected_ruby}" ]]; then
  echo "Ruby version mismatch: expected ${expected_ruby} (.ruby-version), got ${actual_ruby}" >&2
  ruby -v >&2
  exit 1
fi

echo "Ruby ${actual_ruby} matches .ruby-version"
ruby -v
bundle -v

bundle config set --local path 'vendor/bundle'
bundle config set --local force_ruby_platform true
bundle install --jobs=4 --retry=3
