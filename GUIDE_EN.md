# DEV-KIT User Guide (for Complete Beginners)

> A detailed, step-by-step manual designed so that even people new to computers, AI, and software can **just follow along**.
> Korean guide: **[한국어 안내서 → GUIDE.md](./GUIDE.md)**
> (This `.md` document and `GUIDE_EN.pdf` have identical content.)

---

## Table of Contents

1. [What is this?](#1-what-is-this)
2. [Before you start (requirements)](#2-before-you-start-requirements)
3. [Quick start — 3 steps](#3-quick-start--3-steps)
4. [How to download](#4-how-to-download)
5. [How to run (incl. the blue warning)](#5-how-to-run-incl-the-blue-warning)
6. [How to use the menu (full reference)](#6-how-to-use-the-menu-full-reference)
7. [Tools that get installed](#7-tools-that-get-installed)
8. [How it works internally](#8-how-it-works-internally)
9. [What is a "safe version" (LTS)?](#9-what-is-a-safe-version-lts)
10. [Update / Remove / Check](#10-update--remove--check)
11. [Key commands (copy & paste)](#11-key-commands-copy--paste)
12. [Troubleshooting](#12-troubleshooting)
13. [File & document locations](#13-file--document-locations)
14. [Workflow after install (to your first vibe coding)](#14-workflow-after-install-to-your-first-vibe-coding)
15. [FAQ](#15-faq)
16. [License, Copyright & Commercial Use (Important)](#16-license-copyright--commercial-use-important)

---

## 1. What is this?

To start **"vibe coding"** (building software by talking to AI in natural language), your PC needs several developer tools (Git, Python, etc.) installed first. Installing them one by one takes 30–60 minutes and is error-prone.

**Just run `dev-one-click-setting-kit.bat`** and it installs the required tools **automatically**.

- Tools already installed are **skipped** (not reinstalled).
- Results are saved to **report files**.
- **Windows only.** It does not work on macOS or Linux.

---

## 2. Before you start (requirements)

| Item | Requirement |
|------|-------------|
| OS | **Windows 10 (21H2 or later)** or **Windows 11** |
| Internet | **Required** (tools are downloaded from the internet) |
| Free disk space | At least **3 GB** (about 5 GB recommended for a full install) |
| winget | The built-in "App Installer" on Windows. If missing, see sections 5 & 12 |

> Administrator rights are **usually not required.** If some tools fail, re-run as administrator (see section 5).

---

## 3. Quick start — 3 steps

1. **Get the file**: download `dev-one-click-setting-kit.bat` from the GitHub page (see section 4).
2. **Run**: **double-click** the file.
3. **Choose**: when the black terminal shows the menu, type **`A`** (Easiest Recommended) or **`1`** (Beginner) and press **Enter**.

> If you're new, **`A`** is recommended — it sets up the basics plus guides you to the AI coding tools in one go.

---

## 4. How to download

**Option 1 — Releases (recommended)**
1. Click **[Releases](../../releases/latest)** on the right of the GitHub repo page.
2. Under **Assets**, click `dev-one-click-setting-kit.bat` to save it.

**Option 2 — Full ZIP**
1. Green **`<> Code`** button → **`Download ZIP`**.
2. **Extract** the ZIP → use `dev-one-click-setting-kit.bat` inside.

> Save it somewhere easy to find, like your **Desktop** or **Downloads** folder.

---

## 5. How to run (incl. the blue warning)

1. **Double-click** `dev-one-click-setting-kit.bat`.
2. (Optional) For best results, right-click the file → **"Run as administrator"**.
3. A **blue warning** ("Windows protected your PC" / SmartScreen) may appear — this is **normal**.
   - Click **[More info]** → then click **[Run anyway]**.
4. On the **first run**, a welcome screen appears once (it won't show again afterwards). Press any key to continue to the menu.

> ⚠️ Antivirus (e.g., Windows Defender) may block `.bat` files. If so, add the file to the allow list or temporarily disable real-time protection and try again.

---

## 6. How to use the menu (full reference)

In the menu, **type a number (or letter) and press Enter**.

| Input | Name | Description |
|-------|------|-------------|
| **A** | Easiest Recommended | **Start here!** Installs the 5 basics + opens Cursor & Claude Desktop download pages |
| **1** | Beginner | 5 basic tools (~7 min) |
| **2** | Intermediate | 11 tools incl. Beginner (~15 min) |
| **3** | Advanced | 16 tools incl. Intermediate (~35 min) |
| **4** | New | 18 tools incl. Advanced (~45 min) |
| **5** | Select Individual | Pick specific tools by number (comma for many: e.g. `1,3,6`) |
| **6** | Safe Update | Check/update installed tools to **stable (LTS) versions** (preview first) |
| **7** | Remove | Remove individual or all tools |
| **8** | Direct Download | When winget fails, opens 24 official site URLs |
| **9** | Check Installation | Shows O/X + version of what's installed |
| **0** | Exit | Close the program |

**Before installing, it asks how to handle already-installed tools:**
`[1] Skip (default) / [2] Upgrade / [3] Remove` — just press **Enter** to safely **Skip**.

> Results are color-coded: **Done = green**, **Failed = red**, menu title = cyan (Windows 10+).

---

## 7. Tools that get installed

> Higher levels include all lower levels (cumulative).

**Beginner (5)** — Git, Python 3, Node.js LTS, VS Code, Windows Terminal
**Intermediate (+6 = 11)** — Git LFS, GitHub CLI, PowerShell 7, pnpm, Bun, Ollama
**Advanced (+5 = 16)** — Java 21 (LTS), Flutter, Go, Rust, Stripe CLI
**New (+2 = 18)** — Ruby, PHP

**Extra in Select Install** — uv (Python package manager), plus npm tools (Vercel, Supabase, Stripe, Resend, Railway, Clerk, Prisma, Uploadthing).

**Installed automatically alongside** — Claude Code CLI (terminal AI coding tool), pip upgrade, npm settings.

**Standalone apps are NOT auto-installed — guided via `[8] Direct Download`** — Cursor, Claude Desktop, GitHub Desktop, LM Studio, Windsurf, Warp. (You install them yourself; they won't be swept in by the "all-in-one" install.)

---

## 8. How it works internally

When you choose an install, it proceeds in order:

1. **Pre-check** — Windows version / winget present / package list refresh / internet / **3 GB disk** / admin-rights notice / detect existing Node·Python.
2. **Install** — in dependency order (e.g., pnpm after Node, Flutter after Java). Each tool installs from the official `winget` source; on failure it **auto-retries once after 5 seconds**, then skips if still failing (never aborts the whole run).
3. **Post-install setup** — Git line-ending config, pip upgrade, disable npm ads, install Claude Code CLI, etc.
4. **Reports** — `install-report-DATE.txt` (summary), `install-log-DATE.txt` (detailed).
5. **PATH verification** — checks that installed tools are recognized as commands.
6. **Done message + elapsed time** + next-step guide.

---

## 9. What is a "safe version" (LTS)?

- This kit installs only **"stable versions," not betas** (based on the official winget source).
- **Node.js and Java are installed as "LTS."** **LTS = a long-term-supported, well-proven version** — the safest choice.
- **[6] Safe Update** follows the same rule: it updates **within the LTS line only** (no sudden jump to experimental builds).

---

## 10. Update / Remove / Check

- **Update [6]**: checks/updates installed tools to stable (LTS) versions. It **shows the upgradable list first**, then asks "proceed? (y/n)".
- **Remove [7]**: `[1] Remove individual` (by number) or `[2] Remove all` (everything this kit installed). Full removal requires typing **Y**.
- **Check [9]**: shows **[O] (installed) / [X] (not found)** and version per tool.

> **Safe to re-run** on the same PC (default "Skip" won't touch existing settings).

---

## 11. Key commands (copy & paste)

After install, open a **new terminal** (Start → Windows Terminal or PowerShell) and verify:

```
git --version
python --version
node --version
claude --version
```

First-time Git setup (once):

```
git config --global user.name  "Your Name"
git config --global user.email "your@email.com"
```

> Right after installing, commands may not work in the **current** window → open a **new terminal** (PATH needs to refresh).

---

## 12. Troubleshooting

| Symptom | What to do |
|---------|------------|
| **"winget not found"** | Install **"App Installer"** from Microsoft Store. Or Settings → Apps → Optional Features → App Installer |
| **Blue warning (SmartScreen)** | [More info] → [Run anyway] (this is normal) |
| **Window closed suddenly** | Check the last lines of `install-log-DATE.txt` in the same folder |
| **A specific tool failed** | Follow the on-screen hint and get just that tool from **[8] Direct Download** |
| **Antivirus blocks it** | Add the file to the allow list, or briefly disable real-time protection |
| **Fails due to permissions** | Right-click the file → "Run as administrator" |
| **Korean text looks broken** | On a Korean Windows it displays correctly. On English Windows the menu may look garbled (improvement planned) |
| **Blocked on a work/school PC** | winget may be blocked by IT policy → use [8] Direct Download |

---

## 13. File & document locations

```
dev-one-click-setting-kit.bat   ← Main executable (this is all you need)
README.md / README_EN.md        ← Short intro (KO / EN)
GUIDE.md  / GUIDE_EN.md          ← This detailed guide (KO / EN)
GUIDE.pdf / GUIDE_EN.pdf         ← Guide as PDF (identical content to the .md)
CHANGELOG.md                    ← Version history
LICENSE                         ← License (MIT)
PRD/                            ← Initial planning docs (reference / v1.0 design record)
```

Files **auto-generated** when you run it (same folder):
- `install-report-DATE.txt` — success/fail/skip summary (for instructors/support)
- `install-log-DATE.txt` — detailed log (for diagnosing errors)

> Marker file `%LOCALAPPDATA%\devkit_intro_seen` — marks that you've seen the welcome screen. Delete it to show the welcome again.

---

## 14. Workflow after install (to your first vibe coding)

1. Install done → open a **new terminal**.
2. Launch **Cursor** (or VS Code). *([8] or [A] opens the Cursor download page — install it yourself.)*
3. **Sign in to Claude** (Claude Desktop, or the `claude` command in the terminal).
4. Open a new **folder** and type what you want to build, **in plain language**.
   - e.g., *"Make a simple memo app"*
5. When the AI generates code, run it. That's vibe coding.

---

## 15. FAQ

**Q. Can I run it again?** — Yes. Default "Skip" makes it safe.
**Q. I only want specific tools.** — Use **[5] Select Individual** and pick by number.
**Q. Is internet required?** — Yes, tools are downloaded online.
**Q. How do I see the welcome screen again?** — Delete `%LOCALAPPDATA%\devkit_intro_seen`.
**Q. Why aren't Cursor / Claude Desktop installed automatically?** — They are standalone apps, so you should install them **yourself**. [8] opens their download pages.

---

## 16. License, Copyright & Commercial Use (Important)

### This kit (dev-one-click-setting-kit)
- **MIT License**, Copyright © 2026 **SoDam AI Studio**.
- Anyone may **freely use, modify, and distribute** it, **including commercial use**.
- However, it is provided **AS IS, without warranty** — the authors are not liable for any damages from its use. See [LICENSE](./LICENSE) for full terms.

### Copyright & licenses of the installed tools
- This kit does **not bundle or redistribute** any tool. It installs from the **official source** of Windows' package manager (winget), or merely **links to official sites**.
- Therefore **the copyright and license of each tool belong to its respective vendor (the original rights holder).**

### ⚠️ Check before any commercial use
- Some installed/linked programs may have **separate terms or paid licenses for commercial (business/enterprise) use.**
  - e.g., **Cursor, Claude Desktop, Docker Desktop** may have different terms for personal vs. business/commercial use.
- **Before using any tool commercially, it is entirely your own responsibility to review and comply with that tool's license / terms of service.**
- This kit (and its authors) bear **no responsibility** for any license violation of the installed tools.

### Disclaimer
- This document and kit are for informational purposes. We strive for accuracy, but **errors may exist.**
- Tool versions, licenses, and download URLs may change over time — **always defer to the official sources.**
