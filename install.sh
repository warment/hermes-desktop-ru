#!/bin/bash
# Hermes Desktop Russian Locale Installer
# Устанавливает русский язык в десктопное приложение Hermes Agent
#
# Использование:
#   curl -sSL https://raw.githubusercontent.com/user/hermes-desktop-ru/main/install.sh | bash
#   или
#   git clone https://github.com/user/hermes-desktop-ru.git && cd hermes-desktop-ru && ./install.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

HERMES_DIR=""
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

log()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }

# --- Find Hermes installation ---
find_hermes() {
  # Check common locations
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

  # Try to find via `which hermes` or process
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

# --- Check if Russian is already installed ---
check_existing() {
  if [ -f "$HERMES_DIR/apps/desktop/src/i18n/ru.ts" ]; then
    if grep -q "Hermes Desktop готов" "$HERMES_DIR/apps/desktop/src/i18n/ru.ts" 2>/dev/null; then
      warn "Русский перевод уже установлен"
      read -p "Переустановить? (y/N) " -n 1 -r
      echo
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
      fi
    fi
  fi
}

# --- Backup ---
backup() {
  local backup_dir="$HERMES_DIR/.ru-backup-$(date +%Y%m%d%H%M%S)"
  mkdir -p "$backup_dir"

  local files=(
    "apps/desktop/src/i18n/types.ts"
    "apps/desktop/src/i18n/languages.ts"
    "apps/desktop/src/i18n/catalog.ts"
    "apps/desktop/src/i18n/en.ts"
    "apps/desktop/src/i18n/zh.ts"
    "apps/desktop/src/app/settings/index.tsx"
    "apps/desktop/src/app/settings/config-settings.tsx"
    "apps/desktop/src/app/settings/keys-settings.tsx"
    "apps/desktop/src/app/settings/model-settings.tsx"
    "apps/desktop/src/app/settings/gateway-settings.tsx"
    "apps/desktop/src/app/settings/mcp-settings.tsx"
    "apps/desktop/src/app/settings/providers-settings.tsx"
    "apps/desktop/src/app/settings/sessions-settings.tsx"
    "apps/desktop/src/app/settings/toolset-config-panel.tsx"
    "apps/desktop/src/app/skills/index.tsx"
  )

  for f in "${files[@]}"; do
    if [ -f "$HERMES_DIR/$f" ]; then
      mkdir -p "$backup_dir/$(dirname "$f")"
      cp "$HERMES_DIR/$f" "$backup_dir/$f"
    fi
  done

  log "Бэкап создан: $backup_dir"
  echo "$backup_dir" > "$HERMES_DIR/.ru-last-backup"
}

# --- Apply patches ---
apply_patches() {
  log "Копирование файлов перевода..."

  # Copy new files
  cp "$REPO_DIR/patches/ru.ts" "$HERMES_DIR/apps/desktop/src/i18n/ru.ts"
  cp "$REPO_DIR/patches/ru-constants.ts" "$HERMES_DIR/apps/desktop/src/app/settings/ru-constants.ts"

  log "Патч i18n системы..."

  # Patch types.ts - add 'ru' to Locale
  cd "$HERMES_DIR"
  if ! grep -q "'ru'" apps/desktop/src/i18n/types.ts; then
    sed -i '' "s/export type Locale = 'en' | 'zh'/export type Locale = 'en' | 'zh' | 'ru'/" apps/desktop/src/i18n/types.ts
    log "types.ts: добавлен 'ru' в Locale"
  fi

  # Patch languages.ts - add ru to LOCALE_OPTIONS and aliases
  if ! grep -q "id: 'ru'" apps/desktop/src/i18n/languages.ts; then
    sed -i '' "/id: 'zh',/a\\
  },\\
  {\\
    id: 'ru',\\
    name: 'Русский',\\
    configValue: 'ru'\\
  }" apps/desktop/src/i18n/languages.ts
    log "languages.ts: добавлен ru в LOCALE_OPTIONS"
  fi

  if ! grep -q "'русский': 'ru'" apps/desktop/src/i18n/languages.ts; then
    sed -i '' "/zh_hans_cn: 'zh'/a\\
  ,\\
  ru: 'ru',\\
  'ru-ru': 'ru',\\
  ru_ru: 'ru',\\
  'русский': 'ru'" apps/desktop/src/i18n/languages.ts
    log "languages.ts: добавлены алиасы"
  fi

  # Patch catalog.ts - import and register ru
  if ! grep -q "import { ru }" apps/desktop/src/i18n/catalog.ts; then
    sed -i '' "s/import { zh } from '.\/zh'/import { ru } from '.\/ru'\\nimport { zh } from '.\/zh'/" apps/desktop/src/i18n/catalog.ts
    sed -i '' "s/en,\\n  zh/en,\\n  zh,\\n  ru/" apps/desktop/src/i18n/catalog.ts
    # More robust: replace the TRANSLATIONS object
    python3 -c "
import re
with open('apps/desktop/src/i18n/catalog.ts', 'r') as f:
    content = f.read()
if 'ru' not in content.split('TRANSLATIONS')[1].split('}')[0]:
    content = content.replace('en,\\n  zh}', 'en,\\n  zh,\\n  ru}')
    with open('apps/desktop/src/i18n/catalog.ts', 'w') as f:
        f.write(content)
" 2>/dev/null || true
    log "catalog.ts: зарегистрирован ru"
  fi

  log "Патч компонентов настроек..."

  # Apply component patches via python (more reliable than sed for complex replacements)
  python3 "$REPO_DIR/scripts/patch-components.py" "$HERMES_DIR"

  log "Патч описаний навыков..."
  python3 "$REPO_DIR/scripts/patch-skills.py" "$HERMES_DIR"
}

# --- Build ---
build() {
  log "Сборка приложения..."
  cd "$HERMES_DIR/apps/desktop"

  if npm run pack 2>&1 | tail -5; then
    log "Сборка завершена успешно"
  else
    error "Ошибка сборки. Проверьте логи выше."
  fi
}

# --- Install LaunchAgent for auto-reapply ---
install_autopatch() {
  local plist_path="$HOME/Library/LaunchAgents/com.hermes-desktop-ru.patcher.plist"
  local script_path="$REPO_DIR/scripts/auto-patch.sh"

  chmod +x "$script_path"

  cat > "$plist_path" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.hermes-desktop-ru.patcher</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$script_path</string>
    </array>
    <key>WatchPaths</key>
    <array>
        <string>$HERMES_DIR/apps/desktop/src/i18n/en.ts</string>
    </array>
    <key>ThrottleInterval</key>
    <integer>10</integer>
</dict>
</plist>
PLIST

  launchctl load "$plist_path" 2>/dev/null || true
  log "Auto-patcher установлен (LaunchAgent)"
}

# --- Main ---
echo ""
echo "🇷🇺 Hermes Desktop Russian Locale Installer"
echo "============================================"
echo ""

if ! find_hermes; then
  error "Hermes Agent не найден. Укажите путь вручную: ./install.sh /path/to/hermes-agent"
fi

log "Hermes найден: $HERMES_DIR"
check_existing
backup
apply_patches
build
install_autopatch

echo ""
echo "============================================"
log "Готово! Русский язык установлен."
echo ""
echo "Запустите Hermes Desktop и выберите:"
echo "  Settings → Appearance → Русский"
echo ""
echo "Для отката: $HERMES_DIR/.ru-backup-*/restore.sh"
echo "Для удаления: ./uninstall.sh"
echo ""
