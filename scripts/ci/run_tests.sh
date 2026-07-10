#!/usr/bin/env bash
set -euo pipefail

mkdir -p tmp/test-results
bundle exec rspec \
  --format progress \
  --format RspecJunitFormatter \
  --out tmp/test-results/rspec.xml
