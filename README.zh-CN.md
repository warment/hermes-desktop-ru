<p align="center">
  <img src="https://img.shields.io/badge/🇷🇺_Hermes_Desktop-Russian_locale_v2-FFD700?style=for-the-badge&labelColor=1a1a2e" alt="Hermes Desktop Russian Locale" width="100%">
</p>

<h1 align="center">🇷🇺 Hermes Desktop — 俄语翻译 (v2)</h1>

<p align="center">
  <a href="https://github.com/NousResearch/hermes-agent"><img src="https://img.shields.io/badge/Hermes_Agent-Official_Repo-FFD700?style=for-the-badge&logo=github" alt="Hermes Agent"></a>
  <a href="https://github.com/warment/hermes-agent/releases"><img src="https://img.shields.io/github/v/release/warment/hermes-agent?style=for-the-badge&color=green" alt="Release"></a>
  <a href="https://github.com/NousResearch/hermes-agent/pull/42705"><img src="https://img.shields.io/badge/PR-#42705-blue?style=for-the-badge" alt="PR #42705"></a>
</p>

<p align="center">
  <b>Hermes Agent 桌面应用的完整俄语本地化 — 约 99% 的界面文本。</b><br>
  <b>适用于 Hermes Agent v0.19.1 (2026-07-30)</b><br>
  [<a href="README.md">Русский</a>] · [<a href="README.en.md">English</a>] · [<b>中文</b>]
</p>

---

## ⚡ 本地化发布

| 版本 | 链接 | 说明 |
|------|------|------|
| **v2.0.0-ru-locale** | [发布](https://github.com/warment/hermes-agent/releases/tag/v2.0.0-ru-locale) | **当前版本。** 完整俄语本地化（约 99%），41 个文件 |
| v1.0.0-ru-locale | [发布](https://github.com/warment/hermes-agent/releases/tag/v1.0.0-ru-locale) | 存档。第一版（i18n 文件） |

需要 Hermes Agent **v0.19.1** (2026-07-30) 或更新版本。

---

## ✨ 翻译内容

<table>
<tr><td><b>全部 38 个 i18n 区块</b></td><td><code>ru.ts</code> 约 3000 行：菜单、设置、账单、通知、快捷键、覆盖窗口、启动画面、安装、引导、状态栏</td></tr>
<tr><td><b>设置字段</b></td><td><code>ru-constants.ts</code>：所有字段的标签和描述</td></tr>
<tr><td><b>账单</b></td><td>验证页面、套餐、自动充值、错误消息</td></tr>
<tr><td><b>应用卸载</b></td><td>危险区：卸载选项、确认、警告</td></tr>
<tr><td><b>Computer Use</b></td><td>权限、驱动健康、就绪状态、确认对话框</td></tr>
<tr><td><b>MoA 预设</b></td><td>Mixture of Agents：预设、聚合器、创建/删除</td></tr>
<tr><td><b>Quick Entry 与宠物覆盖层</b></td><td>独立渲染窗口：已包装 I18nProvider，全部文本</td></tr>
<tr><td><b>表情选择器</b></td><td>搜索、加载、「更多表情」、「Hermes 已回应」</td></tr>
<tr><td><b>星空图</b></td><td>图例、技能、记忆、时间线滑块</td></tr>
<tr><td><b>自定义端点</b></td><td>活跃、API 密钥已设置、删除、空状态、Auto</td></tr>
<tr><td><b>其他</b></td><td>Show options、More actions、OAuth/API key、个人资料、嵌入（Spotify/YouTube）、会话时间线、「无法打开会话」、生成参考图</td></tr>
</table>

技术性字符串有意保留不译：URL 示例、服务商品牌名、配置文件（config.yaml、SOUL.md）。

---

## 📦 安装

### 快速安装 — 一条命令

```bash
curl -sSL https://raw.githubusercontent.com/warment/hermes-agent/main/install.sh | bash
```

或通过 git：

```bash
git clone https://github.com/warment/hermes-agent.git
cd hermes-agent && ./install.sh
```

脚本会自动：查找 Hermes 安装位置、从发布下载语言包、备份、应用全部 41 个文件并重新构建应用。然后安装到 /Applications（先退出 Hermes，Cmd+Q）：

```bash
sudo rm -rf /Applications/Hermes.app
sudo cp -R ~/.hermes/hermes-agent/apps/desktop/release/mac-arm64/Hermes.app /Applications/
```

启动后：**设置** → **外观** → **Русский**

### 分支 feat/desktop-ru-locale（开发者）

```bash
git fetch origin feat/desktop-ru-locale
git checkout feat/desktop-ru-locale
cd apps/desktop && npm run build && npm run pack
```

---

## 🛡️ 自动更新

Hermes 更新后，本地化通过 macOS LaunchAgent **自动重新应用** — 脚本监控源文件并在更新时重新复制翻译。

---

## 📁 包结构

```
hermes-ru-locale-v2.0.0/
├── README.md                # 文档 (RU/EN/ZH)
└── apps/desktop/src/
    ├── i18n/                # ru.ts（约 3000 行）+ 同步的 en/zh/types/catalog/languages
    ├── app/                 # 已翻译组件（设置、账单、覆盖窗口）
    └── components/          # 表情选择器、嵌入、时间线、宠物蛋等
```

---

## 🔧 工作原理

1. `install.sh` 在标准位置查找 Hermes 安装（`~/.hermes/hermes-agent` 等）
2. 备份全部 41 个文件到 `.ru-backup-*`（用于回滚）
3. 复制完整的 i18n 文件（en/zh/types 始终同步 — 类型不会损坏）
4. 将已翻译组件覆盖到源码
5. 重新构建应用（`npm run pack`）
6. 安装 LaunchAgent 以便更新后自动重新应用

---

## ✅ 验证

- `tsc --noEmit` → **0 错误**
- 694 个测试通过（6 个已知的 localStorage 失败与翻译无关）
- 俄语字符串已在构建的 `app.asar` 中确认

---

## 🗑️ 回滚

从 git 恢复原始文件：

```bash
cd ~/.hermes/hermes-agent && git checkout apps/desktop/src
npm run build && npm run pack
```

---

## 📋 要求

- macOS（用于 LaunchAgent 自动修补）
- 标准位置的 Hermes Agent v0.19.1+
- Node.js ≥ 20 和 npm（用于构建）

---

## 📣 上游

主仓库中的 PR：**[#42705 — feat(i18n/desktop): add Russian (ru) locale](https://github.com/NousResearch/hermes-agent/pull/42705)** · Issue：[#40347](https://github.com/NousResearch/hermes-agent/issues/40347)

---

## 🤝 贡献

欢迎：
- 翻译成其他语言
- 错误修复
- 安装器改进

---

## 📄 许可证

MIT License

---

<p align="center">
  <sub>Built with ❤️ for the <a href="https://github.com/NousResearch/hermes-agent">Hermes Agent</a> community</sub>
</p>
