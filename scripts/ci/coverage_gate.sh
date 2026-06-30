#!/usr/bin/env bash
set -euo pipefail

# Artifact extraction can place index.html at either:
# - coverage/index.html
# - ./index.html
if [ -f coverage/index.html ]; then
  COVERAGE_INDEX_PATH="coverage/index.html"
elif [ -f index.html ]; then
  COVERAGE_INDEX_PATH="index.html"
else
  echo "Coverage report index.html not found."
  find . -maxdepth 3 -name index.html -print || true
  exit 1
fi

COVERAGE=$(grep -oE '[0-9]+\.[0-9]+%' "$COVERAGE_INDEX_PATH" | head -n1 | tr -d '%')
if [ -z "$COVERAGE" ]; then
  echo "Unable to parse coverage percentage from $COVERAGE_INDEX_PATH"
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

if (( $(echo "$COVERAGE < $BASELINE" | bc -l) )); then
  echo "Coverage dropped: $COVERAGE% < $BASELINE%"
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
else
  echo "Coverage unchanged at $COVERAGE%"
fi
