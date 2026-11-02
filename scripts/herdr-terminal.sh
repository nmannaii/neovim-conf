#!/usr/bin/env bash
# nvim-dap's external_terminal spawns `command` with argv appended directly
# (no shell, see dap/session.lua:launch_external_terminal) -- there is no
# `herdr` equivalent of `tmux new-window <argv...>` that runs a program
# straight from argv, so this shim creates a tab and types the (quoted)
# command into its shell instead.
set -euo pipefail

label="${HERDR_DAP_LABEL:-debug}"

result=$(herdr tab create --cwd "$PWD" --label "$label" --no-focus)
pane_id=$(printf '%s' "$result" | grep -o '"pane_id":"[^"]*"' | head -n1 | cut -d'"' -f4)
tab_id=$(printf '%s' "$result" | grep -o '"tab_id":"[^"]*"' | head -n1 | cut -d'"' -f4)

if [ -z "$pane_id" ]; then
  echo "herdr-terminal.sh: could not create herdr tab: $result" >&2
  exit 1
fi

cmd=$(printf '%q ' "$@")
# Close this tab once the debuggee exits (any exit code) instead of leaving
# it stranded at the shell prompt after the debug session ends.
if [ -n "$tab_id" ]; then
  cmd="$cmd; herdr tab close $tab_id"
fi
exec herdr pane run "$pane_id" "$cmd"
