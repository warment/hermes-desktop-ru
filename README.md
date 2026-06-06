<p align="center">
  <img src="https://img.shields.io/badge/🇭🇷_Hermes_Desktop-Russian_locale-FFD700?style=for-the-badge&labelColor=1a1a2e" alt="Hermes Desktop Russian Locale" width="100%">
</p>

<h1 align="center">🇭🇷 Hermes Desktop — Русский язык</h1>

<p align="center">
  <a href="https://github.com/NousResearch/hermes-agent"><img src="https://img.shields.io/badge/Hermes_Agent-Official_Repo-FFD700?style=for-the-badge&logo=github" alt="Hermes Agent"></a>
  <a href="https://github.com/warment/hermes-desktop-ru/releases"><img src="https://img.shields.io/github/v/release/warment/hermes-desktop-ru?style=for-the-badge&color=green" alt="Release"></a>
  <a href="https://github.com/warment/hermes-desktop-ru/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License: MIT"></a>
  <a href="https://discord.gg/NousResearch"><img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white" alt="Discord"></a>
</p>

<p align="center">
  <b>Автоматическая установка русского языка в десктопном приложении Hermes Agent.</b><br>
  Одна команда — и весь интерфейс на русском.
</p>

---

## ⚡ Быстрая установка

```bash
git clone https://github.com/warment/hermes-desktop-ru.git
cd hermes-desktop-ru
./install.sh
```

Или одной командой:

```bash
curl -sSL https://raw.githubusercontent.com/warment/hermes-desktop-ru/main/install.sh | bash
```

После установки: **Settings** → **Appearance** → **Русский**

---

## ✨ Что переведено

<table>
<tr><td><b>Навигация настроек</b></td><td>Провайдеры, Аккаунты, API-ключи, Инструменты, Шлюз, MCP, Архивные чаты, О приложении</td></tr>
<tr><td><b>Поля настроек</b></td><td>Все названия и описания (~60 ключей): Окно контекста, Личность, Рабочая директория, Режим выполнения кода и т.д.</td></tr>
<tr><td><b>Состояния загрузки</b></td><td>Загрузка конфигурации, ключей, модели, шлюза, MCP-серверов, провайдеров, сессий</td></tr>
<tr><td><b>Архивные сессии</b></td><td>Заголовок, описание, пустое состояние, кнопки, уведомления</td></tr>
<tr><td><b>Директория проекта</b></td><td>Заголовок, описание, кнопки выбора/очистки</td></tr>
<tr><td><b>MCP серверы</b></td><td>Создание, редактирование, перезагрузка, уведомления (~24 ключа)</td></tr>
<tr><td><b>Шлюз</b></td><td>Локальный/удалённый, URL, аутентификация, диагностика (~35 ключей)</td></tr>
<tr><td><b>Boot экран</b></td><td>Шаги загрузки, ошибки, экран восстановления</td></tr>
<tr><td><b>Titlebar</b></td><td>Кнопки заголовка окна</td></tr>
<tr><td><b>Composer</b></td><td>Поле ввода, голос, вложения, команды, подсказки</td></tr>
<tr><td><b>Sidebar</b></td><td>Навигация по сессиям, поиск, группировка</td></tr>
<tr><td><b>Описания навыков</b></td><td>apple-notes, apple-reminders, findmy, imessage, macos-operations и др.</td></tr>
</table>

---

## 🛡️ Автоматическое обновление

При обновлении Hermes русский перевод **автоматически пере-применяется** через macOS LaunchAgent. Скрипт следит за файлами Hermes и при обновлении снова применяет патч.

---

## 🗑️ Удаление

```bash
./uninstall.sh
```

Восстановит оригинальные файлы из бэкапа и удалит русский перевод.

---

## 📁 Структура

```
hermes-desktop-ru/
├── install.sh              # Установщик
├── uninstall.sh            # Удаление
├── README.md               # Документация
├── patches/
│   ├── ru.ts               # Русский перевод интерфейса (~850 строк)
│   └── ru-constants.ts     # Русские названия полей настроек
└── scripts/
    ├── patch-components.py # Патч компонентов настроек
    ├── patch-skills.py     # Патч описаний навыков
    └── auto-patch.sh       # Auto-reapply при обновлении
```

---

## 🔧 Как это работает

1. `install.sh` находит установку Hermes в стандартных расположениях
2. Создаёт бэкап оригинальных файлов в `.ru-backup-*`
3. Копирует `ru.ts` и `ru-constants.ts` в дерево исходников
4. Патчит `types.ts`, `languages.ts`, `catalog.ts` для регистрации ru
5. Патчит компоненты настроек (заменяет захардкоженные строки на `t.*`)
6. Патчит `skills/index.tsx` для перевода описаний навыков
7. Пересобирает приложение (`npm run pack`)
8. Устанавливает LaunchAgent для auto-reapply при обновлении

---

## 📋 Требования

- macOS (для LaunchAgent auto-patcher)
- Hermes Agent установлен в одном из стандартных расположений
- Node.js и npm (для сборки)

---

## 🤝 Вклад

Приветствуются:
- Переводы на другие языки
- Исправления ошибок
- Улучшения скрипта установки

## 📣 Официальное обсуждение

Issue в основном репозитории Hermes: [#40347](https://github.com/NousResearch/hermes-agent/issues/40347)

---

## 📄 Лизензия

MIT License

---

<p align="center">
  <sub>Built with ❤️ for the <a href="https://github.com/NousResearch/hermes-agent">Hermes Agent</a> community</sub>
</p>
