#!/usr/bin/env bash
set -euo pipefail

PLUGIN_ROOT="${1:?Usage: test-user-prompt-submit.sh <plugin-root>}"

echo "Testing user-prompt-submit hook..."

hook="$PLUGIN_ROOT/hooks/user-prompt-submit"

[[ -x "$hook" ]] || { echo "hook not executable"; exit 1; }

trigger_output="$(echo '{"prompt":"write me a book on AI safety"}' | CLAUDE_PLUGIN_ROOT="$PLUGIN_ROOT" bash "$hook" 2>&1)" || true

if [[ -n "$trigger_output" ]]; then
  echo "$trigger_output" | grep -q "BOOK-MAKER INTENT DETECTED" || {
    echo "trigger phrase did not produce intent detection"
    exit 1
  }
else
  echo "trigger phrase produced no output"
  exit 1
fi

no_trigger_output="$(echo '{"prompt":"fix the CSS bug in header.tsx"}' | CLAUDE_PLUGIN_ROOT="$PLUGIN_ROOT" bash "$hook" 2>&1)" || true

if [[ -n "$no_trigger_output" ]]; then
  echo "$no_trigger_output" | grep -q "INTENT DETECTED" && {
    echo "non-trigger phrase incorrectly triggered intent detection"
    exit 1
  }
fi

echo "user-prompt-submit hook OK"
