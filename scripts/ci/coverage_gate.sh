#!/usr/bin/env bash
set -euo pipefail

# SimpleCov 1.x writes coverage.json alongside index.html and renders the HTML
# report client-side, so line coverage is no longer present as "NN.NN%" literals
# in index.html. Prefer the JSON total.lines.percent field (same value as the
# HTML report). Fall back to grepping legacy SimpleCov 0.x HTML when needed.
read_line_coverage_percent() {
  local source_path="$1"
  python3 -c '
import json
import math
import sys

with open(sys.argv[1], encoding="utf-8") as handle:
    percent = json.load(handle)["total"]["lines"]["percent"]
# Match SimpleCov display: floor to two decimal places (see simplecov#679).
floored = math.floor(percent * 100) / 100
print(f"{floored:.2f}")
' "$source_path"
}

COVERAGE=""
if [ -f coverage/coverage.json ]; then
  COVERAGE_JSON_PATH="coverage/coverage.json"
elif [ -f coverage.json ]; then
  COVERAGE_JSON_PATH="coverage.json"
fi

if [ -n "${COVERAGE_JSON_PATH:-}" ]; then
  COVERAGE=$(read_line_coverage_percent "$COVERAGE_JSON_PATH")
  echo "Read line coverage from $COVERAGE_JSON_PATH"
elif [ -f coverage/index.html ]; then
  COVERAGE_INDEX_PATH="coverage/index.html"
elif [ -f index.html ]; then
  COVERAGE_INDEX_PATH="index.html"
fi

if [ -z "$COVERAGE" ] && [ -n "${COVERAGE_INDEX_PATH:-}" ]; then
  COVERAGE=$(grep -oE '[0-9]+\.[0-9]+%' "$COVERAGE_INDEX_PATH" | head -n1 | tr -d '%')
  echo "Read line coverage from $COVERAGE_INDEX_PATH (legacy HTML)"
fi

if [ -z "$COVERAGE" ]; then
  echo "Coverage report not found (expected coverage/coverage.json or coverage/index.html)."
  find . -maxdepth 3 \( -name coverage.json -o -name index.html \) -print || true
  exit 1
fi
echo "Current coverage: $COVERAGE%"

BASELINE_PATH="coverage/coverage_baseline.txt"
if [ ! -f "$BASELINE_PATH" ] && [ -f coverage_baseline.txt ]; then
  BASELINE_PATH="coverage_baseline.txt"
fi

if [ ! -f "$BASELINE_PATH" ]; then
  echo "Coverage baseline file not found. Expected coverage/coverage_baseline.txt"
  exit 1
fi

BASELINE=$(cat "$BASELINE_PATH")
echo "Baseline coverage: $BASELINE%"

# Allow minor scan/calculation drift between SimpleCov versions and runners.
COVERAGE_TOLERANCE=0.5
MINIMUM_ACCEPTABLE=$(echo "$BASELINE - $COVERAGE_TOLERANCE" | bc -l)
echo "Minimum acceptable coverage: ${MINIMUM_ACCEPTABLE}% (baseline minus ${COVERAGE_TOLERANCE}%)"

if (( $(echo "$COVERAGE < $MINIMUM_ACCEPTABLE" | bc -l) )); then
  echo "Coverage dropped below tolerance: $COVERAGE% < $MINIMUM_ACCEPTABLE% (baseline $BASELINE%)"
  exit 1
fi

if (( $(echo "$COVERAGE > $BASELINE" | bc -l) )); then
  echo "Coverage increased to $COVERAGE% - updating baseline"
  echo "$COVERAGE" > "$BASELINE_PATH"
  git config user.name "github-actions[bot]"
  git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
  git add "$BASELINE_PATH"
  # Only baseline-bot commits use [skip ci] so the push does not re-run the full workflow.
  git commit -m "ci: update coverage baseline to ${COVERAGE}% [skip ci]" || true
  git push origin "HEAD:${GITHUB_HEAD_REF}" || true
elif (( $(echo "$COVERAGE < $BASELINE" | bc -l) )); then
  echo "Coverage within tolerance at $COVERAGE% (baseline $BASELINE%, tolerance ${COVERAGE_TOLERANCE}%)"
else
  echo "Coverage unchanged at $COVERAGE%"
fi
