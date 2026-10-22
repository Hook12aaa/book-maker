#!/usr/bin/env bash
set -euo pipefail

PLUGIN_ROOT="${1:?Usage: test-session-start.sh <plugin-root>}"

echo "Testing session-start hook..."

hook="$PLUGIN_ROOT/hooks/session-start"
bootstrap="$PLUGIN_ROOT/skills/using-book-maker/SKILL.md"

[[ -x "$hook" ]] || { echo "hook not executable"; exit 1; }
[[ -f "$bootstrap" ]] || { echo "bootstrap SKILL.md missing"; exit 1; }

output="$(CLAUDE_PLUGIN_ROOT="$PLUGIN_ROOT" bash "$hook" 2>&1)" || { echo "hook exited non-zero"; exit 1; }
[[ -n "$output" ]] || { echo "hook produced no output"; exit 1; }

echo "$output" | jq -e '.hookSpecificOutput.additionalContext' > /dev/null 2>&1 || {
  echo "output is not valid SessionStart JSON"
  exit 1
}

echo "session-start hook OK"
