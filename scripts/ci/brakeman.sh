#!/usr/bin/env bash
set -euo pipefail

bundle exec brakeman --no-exit-on-warn --no-exit-on-error
