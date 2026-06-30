#!/usr/bin/env bash
set -euo pipefail

echo "=== Runner environment ==="
echo "uname: $(uname -a)"
echo "ruby: $(ruby -v 2>/dev/null || echo missing)"
echo "bundle: $(bundle -v 2>/dev/null || echo missing)"
echo "node: $(node -v 2>/dev/null || echo missing)"
echo "yarn: $(yarn -v 2>/dev/null || echo missing)"
echo "chrome: ${CHROME_BIN:-not set}"
echo "PATH: ${PATH}"
