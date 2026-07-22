# Dev_One-Click_Setting_Kit — One-Click Vibe-Coding Setup Kit

> A tool that installs the developer programs you need to start AI coding (“vibe coding”) on a Windows PC — with **one double-click of a single file**.
> Made so that **even people new to computers and AI** can just follow along.

**Other formats / languages:** [한국어 (README.md)](./README.md) · [Korean HTML (README.html)](./README.html) · [English HTML (README_EN.html)](./README_EN.html)

---

## Table of Contents

1. [What is this?](#1-what-is-this)
2. [Prerequisites](#2-prerequisites)
3. [Programs installed (tool list)](#3-programs-installed-tool-list)
4. [How to download](#4-how-to-download)
5. [Quick start (3-minute summary)](#5-quick-start-3-minute-summary)
6. [How to run](#6-how-to-run)
7. [How to use (menu guide)](#7-how-to-use-menu-guide)
8. [How it works & commands](#8-how-it-works--commands)
9. [Changelog summary](#9-changelog-summary)
10. [File / document locations](#10-file--document-locations)
11. [Workflow](#11-workflow)
12. [Architecture](#12-architecture)
13. [Security / data flow](#13-security--data-flow)
14. [Troubleshooting](#14-troubleshooting)
15. [FAQ](#15-faq)
16. [Legal / copyright / license / commercial use](#16-legal--copyright--license--commercial-use)

---

## 1. What is this?

“Vibe coding” means **making software by asking an AI in plain language**.
But to do AI coding you first need several **developer tools** (Git, Python, Node.js, etc.) on your PC.
Installing them one by one takes 30–60 minutes the first time and is error-prone.

With this kit, running **just `dev-one-click-setting-kit.bat`** will:

- **automatically find and install** the tools you need,
- **skip or upgrade** tools you already have, and
- create a **result summary file** when done.

> ⚠️ **Windows only.** It does not work on macOS or Linux.

**Glossary (all a beginner needs)**

| Term | In plain words |
|------|---------------|
| Terminal / console | The black screen where you type commands |
| winget | Windows’ built-in “automatic program installer” |
| CLI | A program you use by typing commands instead of clicking |
| LTS | “Long-Term Support” — a stable, long-supported version |

---

## 2. Prerequisites

| Item | Requirement |
|------|-------------|
| OS | **Windows 10 (21H2, build 19044+)** or **Windows 11** |
| Internet | **Required** (winget downloads tools from the internet) |
| Free disk space | ~3 GB for Beginner, ~7 GB+ for a full install |
| Privileges | **Admin not required** (mostly). Run as admin only if some tools fail |
| winget | Usually built into Windows 10/11. If missing, see [Troubleshooting](#14-troubleshooting) |

> On older Windows 10 (21H1 or below) winget is unstable; the kit warns you and asks whether to continue.

---

## 3. Programs installed (tool list)

Installation is split into **4 cumulative levels**. Higher levels include all lower ones.

| Level | Cumulative | Tools added | Est. time |
|-------|:---------:|-------------|:--------:|
| **Beginner** | 5 | Git · Python 3 · Node.js LTS · VS Code · Windows Terminal | ~7 min |
| **Intermediate** | 11 | + Git LFS · GitHub CLI · PowerShell 7 · pnpm · Bun · Ollama | ~15 min |
| **Advanced** | 16 | + Java 21 LTS · Go · Rust · Flutter+Dart · Stripe CLI | ~35 min |
| **All-in-one** | 18 | + Ruby · PHP | ~45 min |

**Extra choices ([5] Custom install)**

- winget tool: **uv** (Python package manager)
- npm tools (Y/N each): Vercel CLI · Supabase CLI · Stripe SDK · Resend SDK · Railway CLI · Clerk · Prisma · Uploadthing

**Specific versions ([V] Version-select install)** — stable/LTS only

- **Python**: 3.11 / 3.12 / 3.13
- **Java (JDK)**: 8 / 11 / 17 / 21 (all LTS)
- **Ruby**: 3.2 / 3.3

**Automatic post-install steps**

- Sets Git line-ending option (`core.autocrlf true`) automatically
- Git name/email are **only shown as guidance, never auto-saved** (privacy)
- Upgrades Python `pip`, turns off Node’s ad message (`npm config set fund false`)
- **Installs Claude Code CLI** (reports success/failure honestly)
- Ollama local AI models are **only announced** (not auto-downloaded — large)
- Prints a **PATH check** so you can confirm tools are recognized

> AI editors (Cursor, Claude Desktop, etc.) are **apps**, so they are not auto-installed; **[8] Direct download** opens their official pages instead.

---

## 4. How to download

**Option A — Releases (recommended)**
Repo page → **Releases** → latest → under **Assets** click `dev-one-click-setting-kit.bat` and save.

**Option B — ZIP**
`< > Code` → **Download ZIP** → unzip → use `dev-one-click-setting-kit.bat` inside.

> You only need the single `.bat` file. Other files are docs / dev history.

---

## 5. Quick start (3-minute summary)

1. **Double-click** `dev-one-click-setting-kit.bat`.
2. If a blue SmartScreen warning appears: **[More info] → [Run anyway]**.
3. At the menu, first-timers press **`A`** (easiest recommended) or **`1`** (Beginner) + **Enter**.
4. Press **`Y`** to start; for the “already installed” prompt just press **Enter** (skip).
5. When done, open a **new terminal** as instructed and start using it.

---

## 6. How to run

1. **Get the file** → [4. Download](#4-how-to-download).
2. **Double-click.** Admin usually not needed. If some tools fail, **right-click → “Run as administrator.”**
3. A **blue SmartScreen** window is normal: **[More info] → [Run anyway].**
4. A black screen (terminal) shows a menu. Type a number/letter and press **Enter**.

> Downloads take time. **Do not close the window.**

---

## 7. How to use (menu guide)

The main menu shown on run:

```
[1] Beginner install     first time (5 tools,  ~7 min)
[2] Intermediate install (11 tools, ~15 min)
[3] Advanced install     (16 tools, ~35 min)
[4] All-in-one install   (18 tools, ~45 min)
[5] Custom install       pick only the numbers you want
[6] Update               update installed tools to stable (LTS)
[7] Remove               uninstall tools (single/all)
[8] Direct download      official site URL list (if winget fails)
[9] Check install        O/X + versions
[0] Exit
[A] Easiest recommended  first-timers start here (5 basics + AI guide)
[V] Version-select       specific stable versions (Python/Java/Ruby)
```

| Menu | Description |
|------|-------------|
| **[1]–[4]** | Level install. Shows the list & time and asks **Y/N** before installing |
| **[A]** | Installs the 5 basics + opens Cursor / Claude Desktop download pages |
| **[5]** | Enter numbers with commas (e.g., `1,3,8`). **Press Enter alone = recommended pack (1–5).** Shows the **names** of chosen tools before installing |
| **[V]** | Choose a **specific stable version** of Python/Java/Ruby. Not sure? Just press Enter (recommended) |
| **[6]** | Updates only the tools this kit installed, to **stable (LTS)** |
| **[7]** | Remove single or all |
| **[8]** | Opens official download pages in your browser when winget fails (URLs: **Ctrl+Click**) |
| **[9]** | Shows each tool’s install state (O/X) and version |

---

## 8. How it works & commands

You only ever **type menu numbers** — there are no commands to memorize.
After installing, in a **new terminal** you can confirm things installed:

```
git --version
python --version
node --version
claude --version
```

**First time with Git (once)** — set your name/email (the kit only guides, never auto-saves):

```
git config --global user.name  "Your Name"
git config --global user.email "your@email.com"
```

---

## 9. Changelog summary

<details>
<summary><b>v1.5.0 (2026-07-22) — latest</b></summary>

- **Fixed**: honest install reporting (removed fake “done”), per-level disk check, Cursor-first hint in [8], accurate elapsed time
- **Added**: [5] **Enter = recommended pack** + **name preview of selected tools**, **[V] Version-select install** (Python 3.11–13 / Java 8·11·17·21 LTS / Ruby 3.2·3.3), version coverage aligned across install/update/remove
- **UX**: [5] menu readability reorganized (grouped & aligned)
- **Encoding**: the UTF-8 (chcp 65001) switch was **reverted** due to a cmd.exe parser bug; the verified **CP949** encoding is kept (works on Korean Windows)
</details>

<details>
<summary>v1.4.0 (2026-06-17)</summary>

- Wider install scope (uv, etc.), clarified stable (LTS) baseline, added [A] recommended install / first-run guidance / colored results. Standalone apps (Cursor, etc.) moved to [8] Direct download.
</details>

<details>
<summary>v1.3.0 / v1.2.0 / v1.1.0 (2026-04–06)</summary>

- Regression fixes, new Direct-download menu ([8]), added Git LFS & Stripe CLI, disk check / retry / elapsed-time stabilization.
</details>

<details>
<summary>v1.0.0 (2026-04-20)</summary>

- First release: winget-based one-click install, 4 levels, 2 report files, remove/check menus.
</details>

> Full history: [CHANGELOG.md](./CHANGELOG.md)

---

## 10. File / document locations

All docs are at the **project root**.

```
dev-one-click-setting-kit.bat   ← main executable (all you need)
README.md / README.html          ← Korean guide (identical content)
README_EN.md / README_EN.html    ← English guide (identical content)
CHANGELOG.md                     ← version history
LICENSE                          ← license (Apache License 2.0)
PRD/                            ← early planning docs (reference)
*.py                             ← past dev patch records (not needed to run)
```

> Auto-created on run: `install-report-DATE.txt` (summary), `install-log-DATE.txt` (detail) — excluded from the repo by `.gitignore`.

---

## 11. Workflow

```
Double-click
  → First-run welcome/notice (once)
  → Menu choice
  → [Pre-check] Windows version · winget · package-list update · internet · disk · existing installs
  → Install tools (dependency order: Git → Python/Node → pnpm/Bun → Java → Flutter …)
      · If present: skip / upgrade choice
      · On failure: auto-retry once after 5s → then skip (points to [8])
  → Post-install setup (Git line-endings, pip upgrade, etc.)
  → Save 2 reports + print PATH check
  → “Open a new terminal to start” message
```

---

## 12. Architecture

- **Single file**: one pure Windows batch script (`.bat`). No separate install/build.
- **Package manager**: **winget** (Microsoft-official, signature-verified). Each tool comes from its official source.
- **Structure (subroutines)**: menu → `:PRE_CHECK` → `:INSTALL` / `:NPM_INSTALL` (install + retry) → `:POST_*` (post-install) → `:MAKE_REPORTS` → `:PATH_CHECK`.
- **Portability**: `%~dp0`-based, so it works even if you rename/move the file.
- **Encoding**: CP949 (for Korean Windows). On English Windows the menu text may look garbled (known limitation — see [14](#14-troubleshooting)).

---

## 13. Security / data flow

- **No admin required** (user-scope install). Works on corporate/school PCs.
- **Official source only**: every install uses `--source winget` (Microsoft signature-verified). No arbitrary-URL execution path.
- **Minimal input**: you type **only menu numbers**. No path for running arbitrary commands.
- **Privacy**: Git name/email are **only shown, never auto-saved**.
- **No external transmission**: the only files created are **local** (report/log). Nothing is sent to a server.
- **Report contents**: PC name (COMPUTERNAME) and results only. **No username, home path, or passwords.**
- **No secrets**: the code/docs contain no API keys, tokens, or passwords.

---

## 14. Troubleshooting

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| Blue SmartScreen window | Windows protection | **[More info] → [Run anyway]** (normal) |
| `winget not found` | App Installer missing | Install **“App Installer”** from Microsoft Store, or https://aka.ms/getwinget |
| Window closes suddenly mid-install | An error occurred | Check the **last line** of `install-log-DATE.txt` in the same folder |
| Only a specific tool fails | Network/policy/winget hiccup | It auto-retries once; if still failing, use **[8] Direct download** |
| Fails even as admin | Antivirus blocks the `.bat` | Add it to the allowlist, or briefly disable real-time protection and retry |
| **Menu text looks garbled** | **English (non-Korean) Windows** | Fine on Korean Windows. On English Windows this is a known limitation (a PowerShell launcher is planned) |
| Low-disk warning | Not enough free space | Free up space and rerun (levels need 3/4/6/7 GB) |

> When reporting an error, attach `install-log-DATE.txt` instead of a screenshot — it makes diagnosis easier. (No sensitive info inside.)

---

## 15. FAQ

**Q. I’ve never coded — can I use it?**
Yes. Just pressing **[A]** or **[1]** sets up a basic environment.

**Q. Is it safe to run again?**
Yes. Already-installed tools default to **skip**, so it’s safe.

**Q. Do I really need admin rights?**
Usually no. It guides you to admin only when a tool fails.

**Q. Can I install a specific version (e.g., Python 3.11)?**
Yes — via **[V] Version-select install**, stable versions only.

**Q. How do I remove what I installed?**
**[7] Remove** → single or all.

**Q. Is internet required?**
Yes. winget downloads the tools from the internet.

**Q. Does it work on macOS/Linux?**
No. **Windows only.**

---

## 16. Legal / copyright / license / commercial use

> **Notice (disclaimer):** This section is **general information for reference only** and **does not constitute legal advice or guarantee any legal effect.** For important decisions (commercial distribution, redistribution, etc.), **consult a qualified professional such as a lawyer.**

**1) License of this kit (code/docs)**

- **Apache License 2.0** — Copyright © 2026 **SoDam AI Studio**. Full text: [LICENSE](./LICENSE).
- Permits: **free use, modification, distribution, and commercial use.**
- Conditions: on distribution, **include a copy of the license**, **state changes**, keep copyright notices.
- Limitation: **no trademark rights** granted (do not use the “SoDam AI Studio” name/logo without permission).
- Warranty: **AS-IS, no warranty** — the authors are not liable for damages from use (Apache 2.0 §7–8).

**2) Licenses of the “third-party tools” this kit installs (important)**

- This kit does **not redistribute** any tool; it merely **downloads and installs each tool’s official build via winget**.
- Each installed tool (Git, Python, Node.js, VS Code, Java, Go, Rust, Flutter, Ruby, PHP, Ollama, etc.) is governed by **its own license** (e.g., Git = GPLv2, Python = PSF, Node.js/pnpm = MIT, VS Code/Go = their respective open-source licenses).
- **For commercial use / redistribution, you must review and comply with each tool’s license separately.** This kit’s Apache 2.0 **does not apply to the installed tools.**

**3) Notes on use**

- Everything installs only from winget’s official (Microsoft-verified) source, and this kit sends none of your data anywhere.
- Responsibility for final installation and use rests with **the user.**

---

<sub>By SoDam AI Studio · License: Apache License 2.0 · Windows only</sub>
