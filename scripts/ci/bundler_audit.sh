#!/usr/bin/env bash
set -euo pipefail

bundle exec bundler-audit update
bundle exec bundler-audit check
