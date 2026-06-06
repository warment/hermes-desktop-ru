#!/bin/bash
# Auto-patcher: re-applies Russian translation after Hermes updates
# Triggered by LaunchAgent when en.ts changes (indicating an update)

REPO_DIR="$(dirname "$(dirname "$0")")"
HERMES_DIR=""

find_hermes() {
  local candidates=(
    "$HOME/.hermes/hermes-agent"
    "$HOME/hermes-agent"
    "$HOME/Dev/hermes-agent"
    "$HOME/projects/hermes-agent"
  )
  for dir in "${candidates[@]}"; do
    if [ -d "$dir/apps/desktop/src/i18n" ]; then
      HERMES_DIR="$dir"
      return 0
    fi
  done
  return 1
}

if ! find_hermes; then
  exit 0
fi

# Check if Russian was previously installed
if [ ! -f "$HERMES_DIR/.ru-last-backup" ]; then
  exit 0
fi

# Check if ru.ts still exists (was overwritten by update)
if [ ! -f "$HERMES_DIR/apps/desktop/src/i18n/ru.ts" ]; then
  echo "[$(date)] Hermes updated, re-applying Russian translation..."
  cd "$REPO_DIR"
  bash install.sh --silent 2>/dev/null
fi
