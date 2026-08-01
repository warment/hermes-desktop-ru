<p align="center">
  <img src="https://img.shields.io/badge/🇷🇺_Hermes_Desktop-Russian_locale_v2-FFD700?style=for-the-badge&labelColor=1a1a2e" alt="Hermes Desktop Russian Locale" width="100%">
</p>

<h1 align="center">🇷🇺 Hermes Desktop — Русский язык (v2)</h1>

<p align="center">
  <a href="https://github.com/NousResearch/hermes-agent"><img src="https://img.shields.io/badge/Hermes_Agent-Official_Repo-FFD700?style=for-the-badge&logo=github" alt="Hermes Agent"></a>
  <a href="https://github.com/warment/hermes-agent/releases"><img src="https://img.shields.io/github/v/release/warment/hermes-agent?style=for-the-badge&color=green" alt="Release"></a>
  <a href="https://github.com/NousResearch/hermes-agent/pull/42705"><img src="https://img.shields.io/badge/PR-#42705-blue?style=for-the-badge" alt="PR #42705"></a>
  <a href="https://github.com/warment/hermes-agent/releases"><img src="https://img.shields.io/github/downloads/warment/hermes-agent/total?style=for-the-badge&color=orange" alt="Downloads"></a>
  <a href="https://github.com/warment/hermes-agent"><img src="https://img.shields.io/github/stars/warment/hermes-agent?style=for-the-badge&color=purple" alt="Stars"></a>
  <a href="https://discord.gg/NousResearch"><img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white" alt="Discord"></a>
</p>

<p align="center">
  <b>Полная русификация десктопного приложения Hermes Agent — ~99% всех строк интерфейса.</b><br>
  <b>Сделано для версии Hermes Agent v0.19.1 (2026-07-30)</b><br>
  [<b>Русский</b>] · [<a href="README.en.md">English</a>] · [<a href="README.zh-CN.md">中文</a>]
</p>

---

## ⚡ Релизы перевода

| Версия | Ссылка | Описание |
|--------|--------|----------|
| **v2.0.0-ru-locale** | [Релиз](https://github.com/warment/hermes-agent/releases/tag/v2.0.0-ru-locale) | **Актуальная.** Полная русификация (~99%), 41 файл |
| v1.0.0-ru-locale | [Релиз](https://github.com/warment/hermes-agent/releases/tag/v1.0.0-ru-locale) | Архив. Первая версия (i18n-файлы) |

Требуется Hermes Agent **v0.19.1** (2026-07-30) или новее.

---

## ✨ Что переведено

<table>
<tr><td><b>Все 38 секций i18n</b></td><td>~3000 строк <code>ru.ts</code>: меню, настройки, биллинг, уведомления, горячие клавиши, мастер-оверлеи, boot-экран, установка, онбординг, статус-бар</td></tr>
<tr><td><b>Поля настроек</b></td><td><code>ru-constants.ts</code>: все названия и описания полей</td></tr>
<tr><td><b>Биллинг</b></td><td>Страница проверки, планы, автопополнение кредитов, сообщения об ошибках</td></tr>
<tr><td><b>Удаление приложения</b></td><td>Danger zone: варианты удаления, подтверждения, предупреждения</td></tr>
<tr><td><b>Computer Use</b></td><td>Разрешения, driver health, состояния готовности, окна подтверждений</td></tr>
<tr><td><b>MoA-пресеты</b></td><td>Mixture of Agents: пресеты, агрегатор, создание/удаление</td></tr>
<tr><td><b>Quick Entry и пет-оверлей</b></td><td>Отдельные renderer-окна: обёрнуты в I18nProvider, все строки</td></tr>
<tr><td><b>Эмодзи-пикер</b></td><td>Поиск, загрузка, «Ещё эмодзи», «Реакция Hermes»</td></tr>
<tr><td><b>Star map</b></td><td>Легенда, навык, память, ползунок таймлайна</td></tr>
<tr><td><b>Пользовательские эндпоинты</b></td><td>Активный, API-ключ задан, удаление, пустое состояние, Auto</td></tr>
<tr><td><b>Разное</b></td><td>Show options, More actions, OAuth/API key, профили, вложения (Spotify/YouTube), таймлайны сессий, «Не удалось открыть сессию», референсы генерации</td></tr>
</table>

Сознательно не переведены технические строки: URL-примеры, имена провайдеров, файлы-конфиги (config.yaml, SOUL.md).

---

## 📦 Установка

### Быстрая установка — одной командой

```bash
curl -sSL https://raw.githubusercontent.com/warment/hermes-agent/main/install.sh | bash
```

Или через git:

```bash
git clone https://github.com/warment/hermes-agent.git
cd hermes-agent && ./install.sh
```

Скрипт сам: найдёт установку Hermes, скачает пакет перевода из релиза, сделает бэкап, применит 41 файл и соберёт приложение. Затем установите в /Applications (закрыв Hermes, Cmd+Q):

```bash
sudo rm -rf /Applications/Hermes.app
sudo cp -R ~/.hermes/hermes-agent/apps/desktop/release/mac-arm64/Hermes.app /Applications/
```

После запуска: **Settings** → **Appearance** → **Русский**

### Ветка feat/desktop-ru-locale (для разработчиков)

```bash
git fetch origin feat/desktop-ru-locale
git checkout feat/desktop-ru-locale
cd apps/desktop && npm run build && npm run pack
```

---

## 🛡️ Автоматическое обновление

При обновлении Hermes перевод **автоматически пере-применяется** через macOS LaunchAgent — скрипт следит за файлами исходников и при обновлении снова копирует файлы перевода.

---

## 📁 Структура пакета

```
hermes-ru-locale-v2.0.0/
├── README.md                # Документация (RU/EN/ZH)
└── apps/desktop/src/
    ├── i18n/                # ru.ts (~3000 строк) + синхронизированные en/zh/types/catalog/languages
    ├── app/                 # Переведённые компоненты (настройки, биллинг, оверлеи)
    └── components/          # Эмодзи-пикер, вложения, таймлайны, pet-egg и др.
```

---

## 🔧 Как это работает

1. `install.sh` находит установку Hermes в стандартных расположениях (`~/.hermes/hermes-agent` и др.)
2. Создаёт бэкап всех 41 файла в `.ru-backup-*` (для отката)
3. Копирует полные i18n-файлы (en/zh/types всегда синхронизированы — типы не ломаются)
4. Копирует переведённые компоненты поверх исходников
5. Пересобирает приложение (`npm run pack`)
6. Устанавливает LaunchAgent для auto-reapply при обновлении

---

## ✅ Проверки

- `tsc --noEmit` → **0 ошибок**
- 694 теста passed (6 известных фейлов localStorage, не связаны с переводом)
- Русские строки подтверждены в собранном `app.asar`

---

## 🗑️ Откат

Восстановите оригинальные файлы из git:

```bash
cd ~/.hermes/hermes-agent && git checkout apps/desktop/src
npm run build && npm run pack
```

---

## 📋 Требования

- macOS (для LaunchAgent auto-patcher)
- Hermes Agent v0.19.1+ в одном из стандартных расположений
- Node.js ≥ 20 и npm (для сборки)

---

## 📣 Официальное обсуждение

PR в основном репозитории Hermes: **[#42705 — feat(i18n/desktop): add Russian (ru) locale](https://github.com/NousResearch/hermes-agent/pull/42705)** · Issue: [#40347](https://github.com/NousResearch/hermes-agent/issues/40347)

---

## 🤝 Вклад

Приветствуются:
- Переводы на другие языки
- Исправления ошибок
- Улучшения скрипта установки

---

## 📄 Лицензия

MIT License

---

<p align="center">
  <sub>Built with ❤️ for the <a href="https://github.com/NousResearch/hermes-agent">Hermes Agent</a> community</sub>
</p>
