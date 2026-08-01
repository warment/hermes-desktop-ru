#!/bin/bash
# Hermes Desktop Russian Locale Installer (v2, 2026-08-01)
# Полная русификация Hermes Agent Desktop (~99%) — Hermes v0.19.1+
#
# Использование:
#   curl -sSL https://raw.githubusercontent.com/warment/hermes-agent/main/install.sh | bash
#   или
#   git clone https://github.com/warment/hermes-agent.git && cd hermes-agent && ./install.sh [путь-к-hermes-agent]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

HERMES_DIR="${1:-}"
REPO_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd)"
VERSION="v2.0.0-ru-locale"
ASSET_URL="https://github.com/warment/hermes-agent/releases/download/$VERSION/hermes-ru-locale-v2.0.0.zip"

log()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }

# Список файлов перевода (для бэкапа)
FILES=(
  "apps/desktop/src/i18n/catalog.ts"
  "apps/desktop/src/i18n/en.ts"
  "apps/desktop/src/i18n/languages.ts"
  "apps/desktop/src/i18n/ru.ts"
  "apps/desktop/src/i18n/types.ts"
  "apps/desktop/src/i18n/zh.ts"
  "apps/desktop/src/app/settings/ru-constants.ts"
  "apps/desktop/src/app/chat/index.tsx"
  "apps/desktop/src/app/chat/session-tile.tsx"
  "apps/desktop/src/app/chat/sidebar/profile-switcher.tsx"
  "apps/desktop/src/app/contrib/controller.tsx"
  "apps/desktop/src/app/contrib/panes.tsx"
  "apps/desktop/src/app/pet-generate/components/generate-unavailable.tsx"
  "apps/desktop/src/app/pet-generate/components/reference-chip.tsx"
  "apps/desktop/src/app/pet-overlay/overlay-root.tsx"
  "apps/desktop/src/app/pet-overlay/pet-overlay-app.tsx"
  "apps/desktop/src/app/quick-entry/quick-entry-app.tsx"
  "apps/desktop/src/app/quick-entry/quick-entry-root.tsx"
  "apps/desktop/src/app/settings/appearance-settings.tsx"
  "apps/desktop/src/app/settings/billing/auto-reload-row.tsx"
  "apps/desktop/src/app/settings/billing/current-plan-card.tsx"
  "apps/desktop/src/app/settings/billing/index.tsx"
  "apps/desktop/src/app/settings/billing/inline-feedback.tsx"
  "apps/desktop/src/app/settings/billing/plans-view.tsx"
  "apps/desktop/src/app/settings/combobox-input.tsx"
  "apps/desktop/src/app/settings/computer-use-panel.tsx"
  "apps/desktop/src/app/settings/custom-endpoints-settings.tsx"
  "apps/desktop/src/app/settings/model-settings.tsx"
  "apps/desktop/src/app/settings/uninstall-section.tsx"
  "apps/desktop/src/app/shell/model-menu-panel.tsx"
  "apps/desktop/src/app/skills/mcp-tab.tsx"
  "apps/desktop/src/app/starmap/star-map.tsx"
  "apps/desktop/src/app/starmap/timeline.tsx"
  "apps/desktop/src/components/assistant-ui/embeds/spotify-embed.tsx"
  "apps/desktop/src/components/assistant-ui/embeds/youtube-embed.tsx"
  "apps/desktop/src/components/assistant-ui/thread/message-reactions.tsx"
  "apps/desktop/src/components/assistant-ui/thread/timeline.tsx"
  "apps/desktop/src/components/assistant-ui/tool/fallback.tsx"
  "apps/desktop/src/components/chat/generated-image-result.tsx"
  "apps/desktop/src/components/pet/pet-egg-hatch.tsx"
  "apps/desktop/src/components/ui/split-button.tsx"
)

# --- Find Hermes installation ---
find_hermes() {
  [ -n "$HERMES_DIR" ] && return 0
  local candidates=(
    "$HOME/.hermes/hermes-agent"
    "$HOME/hermes-agent"
    "/opt/hermes-agent"
    "$HOME/Dev/hermes-agent"
    "$HOME/projects/hermes-agent"
  )
  for dir in "${candidates[@]}"; do
    if [ -d "$dir/apps/desktop/src/i18n" ]; then
      HERMES_DIR="$dir"
      return 0
    fi
  done
  local hermes_bin
  hermes_bin=$(which hermes 2>/dev/null || true)
  if [ -n "$hermes_bin" ]; then
    local real_path
    real_path=$(realpath "$hermes_bin" 2>/dev/null || readlink -f "$hermes_bin" 2>/dev/null || true)
    if [ -n "$real_path" ]; then
      local candidate
      candidate=$(dirname "$(dirname "$real_path")")
      if [ -d "$candidate/apps/desktop/src/i18n" ]; then
        HERMES_DIR="$candidate"
        return 0
      fi
    fi
  fi
  return 1
}

# --- Download package ---
download_package() {
  local tmp_zip="/tmp/hermes-ru-locale-$VERSION.zip"
  local tmp_dir="/tmp/hermes-ru-locale-pkg"
  rm -rf "$tmp_dir"
  mkdir -p "$tmp_dir"
  log "Скачивание пакета перевода ($VERSION)..."
  curl -sSL -o "$tmp_zip" "$ASSET_URL"
  log "Распаковка..."
  unzip -qo "$tmp_zip" -d "$tmp_dir"
  PKG_DIR="$tmp_dir"
}

# --- Backup ---
backup() {
  local backup_dir="$HERMES_DIR/.ru-backup-$(date +%Y%m%d%H%M%S)"
  mkdir -p "$backup_dir"
  for f in "${FILES[@]}"; do
    if [ -f "$HERMES_DIR/$f" ]; then
      mkdir -p "$backup_dir/$(dirname "$f")"
      cp "$HERMES_DIR/$f" "$backup_dir/$f"
    fi
  done
  log "Бэкап создан: $backup_dir"
  echo "$backup_dir" > "$HERMES_DIR/.ru-last-backup"
}

# --- Apply files ---
apply_files() {
  log "Копирование файлов перевода (41 файл)..."
  rsync -a "$PKG_DIR/apps/desktop/src/" "$HERMES_DIR/apps/desktop/src/"
  log "Файлы перевода применены"
}

# --- Build ---
build() {
  log "Сборка приложения (несколько минут)..."
  cd "$HERMES_DIR/apps/desktop"
  set +e
  npm run pack 2>&1 | tail -5
  local rc=${PIPESTATUS[0]}
  set -e
  if [ "$rc" -eq 0 ]; then
    log "Сборка завершена успешно"
  else
    error "Ошибка сборки (код $rc). Проверьте логи выше."
  fi
}

# --- Main ---
echo ""
echo "🇷🇺 Hermes Desktop Russian Locale Installer v2"
echo "=============================================="
echo ""

if ! find_hermes; then
  error "Hermes Agent не найден. Укажите путь вручную: ./install.sh /path/to/hermes-agent"
fi

log "Hermes найден: $HERMES_DIR"
download_package
backup
apply_files
build

echo ""
echo "============================================"
log "Готово! Русский язык установлен (~99% интерфейса)."
echo ""
echo "Запустите Hermes Desktop и выберите:"
echo "  Settings → Appearance → Русский"
echo ""
echo "Для отката: $HERMES_DIR/.ru-backup-*/restore.sh"
echo ""
