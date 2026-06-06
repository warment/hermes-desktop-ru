#!/bin/bash
# Hermes Desktop Russian Locale Uninstaller
# Удаляет русский перевод и восстанавливает оригинальные файлы

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }

HERMES_DIR=""
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

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

echo ""
echo "🇷🇺 Hermes Desktop Russian Locale Uninstaller"
echo "=============================================="
echo ""

if ! find_hermes; then
  error "Hermes Agent не найден"
fi

log "Hermes найден: $HERMES_DIR"

# Restore from backup
if [ -f "$HERMES_DIR/.ru-last-backup" ]; then
  backup_dir=$(cat "$HERMES_DIR/.ru-last-backup")
  if [ -d "$backup_dir" ]; then
    log "Восстановление из бэкапа: $backup_dir"
    cd "$backup_dir"
    find . -type f -name "*.ts" -o -name "*.tsx" | while read f; do
      target="$HERMES_DIR/$f"
      if [ -f "$target" ]; then
        cp "$f" "$target"
      fi
    done
    log "Файлы восстановлены"
  fi
fi

# Remove ru files
rm -f "$HERMES_DIR/apps/desktop/src/i18n/ru.ts"
rm -f "$HERMES_DIR/apps/desktop/src/app/settings/ru-constants.ts"
rm -f "$HERMES_DIR/.ru-last-backup"
rm -rf "$HERMES_DIR"/.ru-backup-*

# Remove LaunchAgent
launchctl unload "$HOME/Library/LaunchAgents/com.hermes-desktop-ru.patcher.plist" 2>/dev/null || true
rm -f "$HOME/Library/LaunchAgents/com.hermes-desktop-ru.patcher.plist"

log "Русский перевод удалён"

# Rebuild
log "Пересборка..."
cd "$HERMES_DIR/apps/desktop"
if npm run pack 2>&1 | tail -3; then
  log "Сборка завершена"
fi

echo ""
log "Готово! Hermes восстановлен в оригинальное состояние."
echo ""
