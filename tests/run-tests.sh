#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
passed=0
failed=0

run_test() {
  local test_file="$1"
  local name
  name="$(basename "$test_file" .sh)"
  if bash "$test_file" "$PLUGIN_ROOT"; then
    echo "PASS: $name"
    passed=$((passed + 1))
  else
    echo "FAIL: $name"
    failed=$((failed + 1))
  fi
}

echo "=== book-maker plugin tests ==="
echo ""

for t in "$SCRIPT_DIR"/hooks/test-*.sh; do
  [[ -f "$t" ]] && run_test "$t"
done

echo ""
echo "Results: $passed passed, $failed failed"

if (( failed > 0 )); then
  exit 1
fi
