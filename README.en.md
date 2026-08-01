<p align="center">
  <img src="https://img.shields.io/badge/🇷🇺_Hermes_Desktop-Russian_locale_v2-FFD700?style=for-the-badge&labelColor=1a1a2e" alt="Hermes Desktop Russian Locale" width="100%">
</p>

<h1 align="center">🇷🇺 Hermes Desktop — Russian Language (v2)</h1>

<p align="center">
  <a href="https://github.com/NousResearch/hermes-agent"><img src="https://img.shields.io/badge/Hermes_Agent-Official_Repo-FFD700?style=for-the-badge&logo=github" alt="Hermes Agent"></a>
  <a href="https://github.com/warment/hermes-agent/releases"><img src="https://img.shields.io/github/v/release/warment/hermes-agent?style=for-the-badge&color=green" alt="Release"></a>
  <a href="https://github.com/NousResearch/hermes-agent/pull/42705"><img src="https://img.shields.io/badge/PR-#42705-blue?style=for-the-badge" alt="PR #42705"></a>
  <a href="https://discord.gg/NousResearch"><img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white" alt="Discord"></a>
</p>

<p align="center">
  <b>Full Russian localization of the Hermes Agent desktop app — ~99% of all UI strings.</b><br>
  <b>Built for Hermes Agent v0.19.1 (2026-07-30)</b><br>
  [<a href="README.md">Русский</a>] · [<b>English</b>] · [<a href="README.zh-CN.md">中文</a>]
</p>

---

## ⚡ Locale releases

| Version | Link | Description |
|---------|------|-------------|
| **v2.0.0-ru-locale** | [Release](https://github.com/warment/hermes-agent/releases/tag/v2.0.0-ru-locale) | **Current.** Full Russian localization (~99%), 41 files |
| v1.0.0-ru-locale | [Release](https://github.com/warment/hermes-agent/releases/tag/v1.0.0-ru-locale) | Archive. First version (i18n files) |

Requires Hermes Agent **v0.19.1** (2026-07-30) or newer.

---

## ✨ What's translated

<table>
<tr><td><b>All 38 i18n sections</b></td><td>~3000 lines of <code>ru.ts</code>: menus, settings, billing, notifications, hotkeys, overlays, boot screen, install, onboarding, status bar</td></tr>
<tr><td><b>Settings fields</b></td><td><code>ru-constants.ts</code>: all field labels and descriptions</td></tr>
<tr><td><b>Billing</b></td><td>Verification page, plans, credit auto-reload, error messages</td></tr>
<tr><td><b>App uninstall</b></td><td>Danger zone: removal options, confirmations, warnings</td></tr>
<tr><td><b>Computer Use</b></td><td>Permissions, driver health, readiness states, confirmation dialogs</td></tr>
<tr><td><b>MoA presets</b></td><td>Mixture of Agents: presets, aggregator, create/delete</td></tr>
<tr><td><b>Quick Entry & pet overlay</b></td><td>Separate renderer windows: wrapped in I18nProvider, all strings</td></tr>
<tr><td><b>Emoji picker</b></td><td>Search, loading, "More emoji", "Reacted by Hermes"</td></tr>
<tr><td><b>Star map</b></td><td>Legend, skill, memory, timeline scrubber</td></tr>
<tr><td><b>Custom endpoints</b></td><td>Active, API key set, delete, empty state, Auto</td></tr>
<tr><td><b>Misc</b></td><td>Show options, More actions, OAuth/API key, profiles, embeds (Spotify/YouTube), session timelines, "Couldn't open session", generation references</td></tr>
</table>

Technical strings are intentionally left untranslated: URL examples, provider brand names, config files (config.yaml, SOUL.md).

---

## 📦 Installation

### Quick install — one command

```bash
curl -sSL https://raw.githubusercontent.com/warment/hermes-agent/main/install.sh | bash
```

Or via git:

```bash
git clone https://github.com/warment/hermes-agent.git
cd hermes-agent && ./install.sh
```

The script locates your Hermes install, downloads the locale package from the release, backs up, applies all 41 files and rebuilds the app. Then install into /Applications (quit Hermes first, Cmd+Q):

```bash
sudo rm -rf /Applications/Hermes.app
sudo cp -R ~/.hermes/hermes-agent/apps/desktop/release/mac-arm64/Hermes.app /Applications/
```

After launch: **Settings** → **Appearance** → **Русский**

### Branch feat/desktop-ru-locale (for developers)

```bash
git fetch origin feat/desktop-ru-locale
git checkout feat/desktop-ru-locale
cd apps/desktop && npm run build && npm run pack
```

---

## 🛡️ Auto-update

When Hermes updates, the locale is **automatically re-applied** via a macOS LaunchAgent — the script watches the source files and re-copies the translation on update.

---

## 📁 Package structure

```
hermes-ru-locale-v2.0.0/
├── README.md                # Docs (RU/EN/ZH)
└── apps/desktop/src/
    ├── i18n/                # ru.ts (~3000 lines) + synced en/zh/types/catalog/languages
    ├── app/                 # Translated components (settings, billing, overlays)
    └── components/          # Emoji picker, embeds, timelines, pet-egg and more
```

---

## 🔧 How it works

1. `install.sh` locates the Hermes installation in standard locations (`~/.hermes/hermes-agent` and others)
2. Backs up all 41 files to `.ru-backup-*` (for rollback)
3. Copies full i18n files (en/zh/types always in sync — types never break)
4. Copies translated components over the sources
5. Rebuilds the app (`npm run pack`)
6. Installs LaunchAgent for auto-reapply on updates

---

## ✅ Verification

- `tsc --noEmit` → **0 errors**
- 694 tests passed (6 known localStorage failures unrelated to translation)
- Russian strings confirmed in the built `app.asar`

---

## 🗑️ Rollback

Restore original files from git:

```bash
cd ~/.hermes/hermes-agent && git checkout apps/desktop/src
npm run build && npm run pack
```

---

## 📋 Requirements

- macOS (for the LaunchAgent auto-patcher)
- Hermes Agent v0.19.1+ in a standard location
- Node.js ≥ 20 and npm (for building)

---

## 📣 Upstream

PR in the main Hermes repo: **[#42705 — feat(i18n/desktop): add Russian (ru) locale](https://github.com/NousResearch/hermes-agent/pull/42705)** · Issue: [#40347](https://github.com/NousResearch/hermes-agent/issues/40347)

---

## 🤝 Contributing

Welcome:
- Translations to other languages
- Bug fixes
- Installer improvements

---

## 📄 License

MIT License

---

<p align="center">
  <sub>Built with ❤️ for the <a href="https://github.com/NousResearch/hermes-agent">Hermes Agent</a> community</sub>
</p>
