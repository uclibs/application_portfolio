#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
expected_ruby="$(tr -d '[:space:]' < "${repo_root}/.ruby-version" | sed 's/^ruby-//')"
actual_ruby="$(ruby -e 'print RUBY_VERSION')"

echo "=== Runner environment ==="
echo "uname: $(uname -a)"

if [[ "${actual_ruby}" != "${expected_ruby}" ]]; then
  echo "ruby: ${actual_ruby} (expected ${expected_ruby} from .ruby-version)" >&2
  exit 1
fi

echo "ruby: $(ruby -v 2>/dev/null || echo missing)"
echo "bundle: $(bundle -v 2>/dev/null || echo missing)"
echo "node: $(node -v 2>/dev/null || echo missing)"
echo "yarn: $(yarn -v 2>/dev/null || echo missing)"
echo "chrome: ${CHROME_BIN:-not set} (${CHROME_VERSION:-version unknown})"
echo "chromedriver: ${CHROMEDRIVER_PATH:-not set} (${CHROMEDRIVER_VERSION:-version unknown})"
echo "PATH: ${PATH}"
