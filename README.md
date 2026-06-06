# 🇷🇺 Hermes Desktop — Русский язык

Автоматическая установка русского языка в [Hermes Agent Desktop](https://github.com/NousResearch/hermes-agent).

## Быстрая установка

```bash
git clone https://github.com/your-username/hermes-desktop-ru.git
cd hermes-desktop-ru
./install.sh
```

Или одной командой (если Hermes установлен в `~/.hermes/hermes-agent`):

```bash
curl -sSL https://raw.githubusercontent.com/your-username/hermes-desktop-ru/main/install.sh | bash
```

## Что устанавливается

- Русский перевод интерфейса (~850 строк)
- Перевод полей настроек (названия + описания)
- Перевод навигации (Провайдеры, Аккаунты, Инструменты и т.д.)
- Перевод страниц: Сессии, MCP, Шлюз
- Перевод описаний навыков
- Автоматический re-patch при обновлении Hermes (LaunchAgent)

## Как включить

1. Запустите Hermes Desktop
2. Откройте **Settings** → **Appearance**
3. Выберите **Русский**

## Что переведено

| Раздел | Статус |
|---|---|
| Навигация настроек | ✅ Полностью |
| Поля настроек (названия + описания) | ✅ Полностью |
| Загрузка состояний | ✅ Полностью |
| Архивные сессии | ✅ Полностью |
| Директория проекта | ✅ Полностью |
| MCP серверы | ✅ Полностью |
| Шлюз (локальный/удалённый) | ✅ Полностью |
| Описания навыков | ✅ Основные |
| Boot экран | ✅ Полностью |
| Titlebar | ✅ Полностью |
| Composer (ввод сообщений) | ✅ Полностью |
| Sidebar | ✅ Полностью |

## Обновление Hermes

При обновлении Hermes русский перевод **автоматически пере-применяется** через LaunchAgent. Если что-то пошло не так:

```bash
cd hermes-desktop-ru
./install.sh
```

## Откат / Удаление

```bash
cd hermes-desktop-ru
./uninstall.sh
```

Это восстановит оригинальные файлы из бэкапа и удалит русский перевод.

## Как это работает

1. `install.sh` находит установку Hermes
2. Создаёт бэкап оригинальных файлов
3. Копирует `ru.ts` и `ru-constants.ts`
4. Патчит `types.ts`, `languages.ts`, `catalog.ts` для регистрации ru
5. Патчит компоненты настроек (заменяет захардкоженные строки на `t.*`)
6. Патчит `skills/index.tsx` для перевода описаний навыков
7. Пересобирает приложение (`npm run pack`)
8. Устанавливает LaunchAgent для auto-reapply

## Структура

```
hermes-desktop-ru/
├── install.sh              # Установщик
├── uninstall.sh            # Удаление
├── README.md               # Эта документация
├── patches/
│   ├── ru.ts               # Русский перевод интерфейса
│   └── ru-constants.ts     # Русские названия полей настроек
└── scripts/
    ├── patch-components.py # Патч компонентов настроек
    ├── patch-skills.py     # Патч описаний навыков
    └── auto-patch.sh       # Auto-reapply при обновлении
```

## Требования

- macOS (для LaunchAgent)
- Hermes Agent установлен в одном из стандартных расположений
- Node.js и npm (для сборки)

## Лизензия

MIT
