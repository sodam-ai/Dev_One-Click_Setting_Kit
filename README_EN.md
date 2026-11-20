# Dev_One-Click_Setting_Kit — One-Click Vibe-Coding Setup Kit

> A tool that installs the developer programs you need to start AI coding (“vibe coding”) on a Windows PC — with **one double-click of a single file**.
> Made so that **even people new to computers and AI** can just follow along.

**Other formats / languages:** [한국어 (README.md)](./README.md) · [Korean HTML (README.html)](./README.html) · [English HTML (README_EN.html)](./README_EN.html)

**License:** Apache License 2.0 · Copyright © 2026 SoDam AI Studio · **commercial use allowed (with conditions)** → details in [§19](#19-legal--copyright--license--commercial-use)

**Document date:** 2026-11-20 · This guide matches the `dev-one-click-setting-kit.bat` on the `main` branch (the file header says **v1.8.1**), and the latest Release is also **v1.8.1**. Differences from earlier versions are listed in [§9](#9-changelog-summary).

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
14. [Environment variables](#14-environment-variables)
15. [Build · test · release](#15-build--test--release)
16. [Operational notes](#16-operational-notes)
17. [Troubleshooting](#17-troubleshooting)
18. [FAQ](#18-faq)
19. [Legal / copyright / license / commercial use](#19-legal--copyright--license--commercial-use)

---

## 1. What is this?

“Vibe coding” means **making software by asking an AI in plain language**.
But to do AI coding you first need several **developer tools** (Git, Python, Node.js, etc.) on your PC.
Installing them one by one takes 30–60 minutes the first time and is error-prone.

With this kit, running **just `dev-one-click-setting-kit.bat`** will:

- **automatically find and install** the tools you need,
- **skip or upgrade** tools you already have, and
- create a **result summary file** when done.
- set up a **mobile (Android) app development environment** from one menu, **[M]** (Flutter · Android Studio · adb).
- set up **web, desktop-app and data/AI/server development environments** and a **Markdown viewer** from one menu, **[D]**.

> ⚠️ **Windows only.** It does not work on macOS or Linux.

**Glossary (all a beginner needs)**

| Term | In plain words |
|------|---------------|
| Terminal / console | The black screen where you type commands |
| winget | Windows’ built-in “automatic program installer” |
| CLI | A program you use by typing commands instead of clicking |
| LTS | “Long-Term Support” — a stable, long-supported version |
| PATH | The list of places where the terminal looks for programs. After installing, open a **new terminal** for it to apply |
| Flutter | Google’s **app-building toolkit**; build once and run on Android and more |
| Android Studio | The **official program** for building and testing Android apps |
| adb | The **connection tool** between your PC and an Android phone over USB |
| Emulator | A **virtual smartphone** running inside your PC |
| Virtualization | A PC feature (turned on in the BIOS) that makes the emulator fast. **Not needed with a real phone** |

---

## 2. Prerequisites

| Item | Requirement |
|------|-------------|
| OS | **Windows 10 (21H2, build 19044+)** or **Windows 11** |
| Internet | **Required** (winget downloads tools from the internet) |
| Free disk space | ~3 GB for Beginner, ~7 GB+ for a full install, **~10 GB for mobile [M]** |
| Privileges | **Admin not required** (mostly). Run as admin only if some tools fail |
| winget | Usually built into Windows 10/11. If missing, see [Troubleshooting](#17-troubleshooting) |
| PowerShell | Built into Windows. The kit uses it for the date, disk check and number validation (some features may not work if it is blocked) |
| Time | Beginner ~7 min to All-in-one ~45 min, **mobile [M] ~30–40 min** (depends on internet speed) |

> On older Windows 10 (21H1 or below) winget is unstable; the kit warns you and asks whether to continue.

---

## 3. Programs installed (tool list)

Installation is split into **4 cumulative levels**. Higher levels include all lower ones.

| Level | Cumulative | Tools added | Est. time |
|-------|:---------:|-------------|:--------:|
| **Beginner** | 6 | Git · Python 3 · Node.js LTS · VS Code · Windows Terminal · scoop | ~7 min |
| **Intermediate** | 12 | + Git LFS · GitHub CLI · PowerShell 7 · pnpm · Bun · Ollama | ~15 min |
| **Advanced** | 17 | + Java 21 LTS · Go · Rust · Flutter+Dart · Stripe CLI | ~35 min |
| **All-in-one** | 19 | + Ruby · PHP | ~45 min |

> **Versions that get installed:** In levels [1]–[4], [A] and item 2 of [5], **Python is version 3.13**. In item 16 of [5] and in All-in-one, **PHP is version 8.4**. The winget repository no longer has the names without a version number (`Python.Python.3`, `PHP.PHP`), so the kit uses the current stable version. For another Python version, pick 3.11 / 3.12 / 3.13 in **[V]**. PHP 8.4 is installed as a zip package. **We could not confirm on this PC, with a real install, that `php -v` works afterwards** — check in a new terminal, and if it does not work, see [§17](#17-troubleshooting).

**Extra choices ([5] Custom install)**

- winget tool: **uv** (Python package manager)
- npm tools (Y/N each): Vercel CLI · Supabase CLI · Stripe SDK · Resend SDK · Railway CLI · Clerk · Prisma · Uploadthing

**Specific versions ([V] Version-select install)** — stable/LTS only

- **Python**: 3.11 / 3.12 / 3.13
- **Java (JDK)**: 8 / 11 / 17 / 21 (all LTS)
- **Ruby**: 3.2 / 3.3

**scoop — auto-included in levels [1]–[4] · standalone via [S]**

- **scoop**: a command-line package manager for developers. Not in winget, so it is installed via the official script (`get.scoop.sh`). It is **auto-included in level installs [1]–[4]** (after the level's Y confirmation) and can also be installed standalone via [S]. Security details: [§13](#13-security--data-flow).

**Flutter — not in winget, installed from the official repository (git)**

- **Flutter+Dart**: winget has no Flutter package, so the kit downloads **stable** from Flutter's official repository (`github.com/flutter/flutter`) with git into `%USERPROFILE%\develop\flutter` (the location Flutter's docs recommend). **Git is required** (included from the Beginner level) and **Java is not needed** for Flutter. If Flutter already exists it is skipped; if the target folder already exists the kit **does not overwrite it** and reports a failure. Afterwards it is **added to your user PATH** so `flutter` works in a new terminal. Security: [§13](#13-security--data-flow); settings changed: [§14](#14-environment-variables).
**Mobile app development — main menu [M] (Flutter + Android)**

A **separate menu** that is not mixed into levels [1]–[4]; existing levels behave exactly as before.

| Item | How it is installed | Notes |
|------|--------------------|-------|
| Git | winget (`Git.Git`) | Needed to fetch Flutter; installed automatically if missing |
| Flutter+Dart | official repository (git) | See above |
| **Android Studio** | winget (`Google.AndroidStudio`) | Official IDE with the Android SDK, emulator and a bundled JDK |
| **adb** (Android platform-tools) | winget (`Google.PlatformTools`) | For testing on a real phone over USB |
| scrcpy (optional) | winget (`Genymobile.scrcpy`) | Mirror and control the phone screen from the PC |

- **[M] menu**: `[1] Mobile basic` (Git · Flutter · Android Studio · adb) · `[2] Basic + scrcpy` · `[3] Pick items` · `[4] After-install guide`. The same tools can also be picked in [5] Custom install (`28` Android Studio · `29` adb · `30` scrcpy).
- **Pre-checks**: ~10 GB free disk (measured: Flutter 2.56 + Android SDK 4.35 + Android Studio 3.09 GB) and whether virtualization is on (for the emulator — **informational only, never blocks the install**; not needed for a real phone).
- **After-install guide (steps that are not automated)**: first Android Studio launch (SDK download) → `flutter doctor --android-licenses` (you accept the licenses **yourself**) → `flutter doctor` → enabling USB debugging on the phone. The kit **does not set environment variables**; it only shows guidance.
- **[9] Check install**: adds Android Studio · adb · scrcpy, and optionally a `flutter doctor` summary (OK / warnings / errors; it can take 1–2 minutes, so it runs only if you press y).
- **iOS apps cannot be built on Windows** (a Mac is required). This kit prepares the Android app development environment.

**Development environments by field — main menu [D]**

A **separate menu** that does not mix with levels [1]–[4] or [M] (existing behavior is unchanged). Pick a field, then only **[Basic] / [Everything]**. Choose with **Up/Down arrows + Enter**, or by **number**.

| Field | [Basic] | [Everything] adds | Notes |
|-------|---------|-------------------|-------|
| Web | Git · Node.js · VS Code · pnpm | GitHub CLI · Bun · Vercel CLI · Supabase CLI | npm tools (Vercel, Supabase) are attempted in the same window even right after Node.js is installed |
| Desktop apps | Git · Node.js · VS Code · **Rust** · **C++ build tools** | GitHub CLI · pnpm | **Administrator account required**, about 10 GB of disk (estimate) |
| Mobile apps | links to main menu **[M]** | | see [M] above |
| Data / AI / Server | Python 3 · uv · VS Code · Ollama | **Docker Desktop** · **PostgreSQL** | Docker and PostgreSQL **need an administrator account** and show a warning/consent screen first |
| Markdown viewer | table below | | one at a time |

- **Why are C++ build tools in Desktop [Basic]?** Building Windows programs with Rust requires the Microsoft C++ build tools (the linker). Without them `cargo build` fails even though Rust is installed. winget's default install leaves out the C++ components, so the kit explicitly selects the **"Desktop development with C++"** workload (several GB, 10–20 minutes).
- **Administrator rights**: C++ build tools, Docker Desktop and PostgreSQL need an **administrator account**. If your account is not in the Administrators group, only those tools are skipped (with the reason shown) and the rest continue. If Windows shows a **permission prompt during install, click Yes**.
- **Docker Desktop**: before installing you read a notice (a restart may be needed · WSL2/virtualization · free for personal/learning use, possibly paid for business use at larger companies) and choose **1 = agree / 2 = continue without it**.
- **PostgreSQL**: you **type the administrator (`postgres`) password on screen during install** (nothing is shown as you type · letters and digits, 8+ characters · typed twice). Afterwards the kit shows **cautions and troubleshooting** (checking the connection · forgotten password · how to stop the service). The password is not stored in the kit's log or report (see [§13](#13-security--data-flow)).
- **Rust note**: if you install only Rust (Advanced · All-in-one · [5] item 14) and the C++ build tools are missing, a note at the end says **"install them from [D] → Desktop apps"** (not shown if already present). The existing install lists are unchanged.
- **Install verification**: for [D] and the Markdown viewers, even when the installer (winget) reports success the kit **checks once more that it is really installed** (program list · executable for Rust and Docker · service for PostgreSQL · component for the C++ build tools). If it cannot confirm, it **does not count it as a success and shows `[확인실패]` (verification failed)**. It may just not be visible right after installing, so **recheck with [9] Check install in a new terminal**. The install method of levels [1]–[4] is unchanged.
- **Remove · update · direct download**: the new tools are also in [6] · [7] · [8]. [7] single remove has **23 Obsidian · 24 MarkText · 25 Zettlr · 26 Docker Desktop · 27 PostgreSQL · 28 C++ build tools**.
  - **When removing PostgreSQL you choose "program only" (keep the data, recommended) or "data too" (cannot be undone, asks once more).** If your data folder is not at the default location you can tell the kit with an environment variable ([§14](#14-environment-variables)).
  - **Remove-all does not include PostgreSQL or the C++ build tools** (they affect database data and other development tools). Use items 27 and 28 of single remove if needed.
  - [6] Update upgrades Obsidian · MarkText · Zettlr · uv. Docker Desktop updates itself, PostgreSQL is left for you to upgrade **after backing up** to protect your data, and the C++ build tools are updated in the Visual Studio Installer.

**Markdown viewer — last item of [D]**

Installs a program that opens `.md` (Markdown) documents nicely, **one at a time**. Each program is described on screen before you choose.

| Viewer | How | Description |
|--------|-----|-------------|
| Obsidian | winget | The most popular note app. Open a whole folder to browse documents. Can look complex at first |
| MarkText | winget | One of the simplest. Free open source (MIT) |
| Zettlr | winget | Good for papers and long writing. Free open source (GPL-3.0) |
| Typora | **opens the official page only** | Paid, so it is not installed automatically (also not in winget) |
| VS Code | nothing to install | Only explains how to preview with `Ctrl+Shift+V` in the editor you already have |

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

**Option A — Download the ZIP (recommended: always the latest code)**
On the repo page, click the green `< > Code` button → **Download ZIP** → **right-click the downloaded file → Extract** → use `dev-one-click-setting-kit.bat` inside the extracted folder.

**Option B — Download from Releases (only for versions that have the file attached)**
Repo page → **Releases** → pick a version → click `dev-one-click-setting-kit.bat` and save it **only if it is listed** under **Assets**.

> ⚠️ **What we found (2026-11-20):** the **v1.8.0 Release has no `.bat` file attached.** The latest **v1.8.1 attaches it again** (v1.7.1 · v1.6.2 · v1.6.1 also have it). The code of v1.8.0 still has a problem where installing Python 3 and PHP fails, so get **v1.8.1 or later**. A v1.7.1 or older file from Option B has no [D] menu.

> You only need the single `.bat` file. Other files are docs / dev history.
>
> **How to check that your file is current:** right-click the `.bat` → open with Notepad; the first comment line shows `DEV-KIT.bat v<number>`. The **[M] mobile menu** is in **v1.7.0 or later**; **number (1/2) answers, number validation and the Enter-repeat fix** are in **v1.7.1 or later**, and **[D] development environments, Markdown viewers and arrow-key selection** are in **v1.8.0 or later**, and the **Python 3 / PHP install fix and the elapsed-time display fix** are in **v1.8.1 or later**. If your file has a lower version, use **Option A (ZIP)** to get the file from the `main` branch.

---

## 5. Quick start (3-minute summary)

1. If you downloaded the ZIP, **unzip it first** (the result files are created in that folder), then **double-click** `dev-one-click-setting-kit.bat` inside the folder.
2. If a blue SmartScreen warning appears: **[More info] → [Run anyway]**.
3. At the menu, first-timers press **`A`** (easiest recommended) or **`1`** (Beginner) + **Enter**. (To build phone apps, press **`M`**.)
4. Answer “start installing?” with **`1`** (yes); the old `y` also works. In level installs, for the “already installed” prompt just press **Enter** (skip).
5. When done, open a **new terminal** as instructed and start using it.

---

## 6. How to run

1. **Get the file** → [4. Download](#4-how-to-download).
2. **Double-click.** Admin usually not needed. If some tools fail, **right-click → “Run as administrator.”**
3. A **blue SmartScreen** window is normal: **[More info] → [Run anyway].**
4. A black screen (terminal) shows a menu. Type a number/letter and press **Enter**.
5. Answer yes/no questions with **`1` = yes / `2` = no**. **Pressing just Enter does not run anything** (questions with a default use the default).

> Downloads take time. **Do not close the window.**

---

## 7. How to use (menu guide)

The main menu shown on run:

```
[1] Beginner install     first time (6 tools,  ~7 min)
[2] Intermediate install (12 tools, ~15 min)
[3] Advanced install     (17 tools, ~35 min)
[4] All-in-one install   (19 tools, ~45 min)
[5] Custom install       pick only the numbers you want
[6] Update               update installed tools to stable (LTS)
[7] Remove               uninstall tools (single/all)
[8] Direct download      official site URL list (if winget fails)
[9] Check install        O/X + versions
[0] Exit
[A] Easiest recommended  first-timers start here (5 basics + AI guide)
[V] Version-select       specific stable versions (Python/Java/Ruby)
[S] Install scoop        dev package manager (non-winget)
[M] Mobile app dev       Flutter + Android Studio + adb (Android)
[D] Dev environments    Web / Desktop / Server / Markdown viewer
```

| Menu | Description |
|------|-------------|
| **[1]–[4]** | Level install. Shows the list & time and asks **Y/N** before installing |
| **[A]** | Installs the 5 basics + opens Cursor / Claude Desktop download pages |
| **[5]** | Enter numbers with commas (e.g., `1,3,8`). **Press Enter alone = recommended pack (1–5).** Shows the **names** of chosen tools before installing |
| **[V]** | Choose a **specific stable version** of Python/Java/Ruby. Not sure? Just press Enter (recommended) |
| **[S]** | Installs **scoop** (dev package manager). Not in winget, so it uses the official script — asks for **consent (Y/N)**. Security: [§13](#13-security--data-flow) |
| **[M]** | Installs the **mobile app development environment** (Git · Flutter · Android Studio · adb · scrcpy) and shows the **after-install guide**. Details: [§3](#3-programs-installed-tool-list) |
| **[D]** | **Development environments by field**: Web / Desktop apps / Mobile (→[M]) / Data·AI·Server / Markdown viewer. Pick a field, then **[Basic] / [Everything]**. Details: [§3](#3-programs-installed-tool-list) |
| **[6]** | Updates only the tools this kit installed, to **stable (LTS)** |
| **[7]** | Remove single or all |
| **[8]** | Opens official download pages in your browser when winget fails (URLs: **Ctrl+Click**) |
| **[9]** | Shows each tool’s install state (O/X) and version |

**Yes/no questions** can be answered with `1` (yes) / `2` (no), and the old `y`/`n` still works. Pressing just Enter does **not** run anything. Invalid numbers in [5]/[M] show a hint and ask again.

The selection screens **inside [D]** are chosen by **moving with the Up/Down arrows and pressing Enter**, or by **pressing a number** (`0` or `Esc` = back). If the arrow screen cannot be used in your environment, it **switches to number input automatically**. The existing menus ([1]–[9], [M], etc.) still use number input.

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

**If you installed mobile ([M]) — check in a new terminal**

```
flutter --version
flutter doctor
adb version
```

- `flutter doctor`: shows the readiness of app development item by item. If it shows warnings, follow the [M] → [4] guide in order.
- `adb version`: confirms adb (the phone connection tool) is installed. Use `adb devices` to see whether the phone is visible.

**First time with Git (once)** — set your name/email (the kit only guides, never auto-saves):

```
git config --global user.name  "Your Name"
git config --global user.email "your@email.com"
```

---

## 9. Changelog summary

<details open>
<summary><b>v1.8.1 (2026-11-20) — latest Release</b></summary>

- **Fixed (important)**: replaced 2 winget names that no longer exist — `Python.Python.3` → `Python.Python.3.13`, `PHP.PHP` → `PHP.PHP.8.4`. Both names are gone from the winget repository (looked up 2026-11-20), so **Python 3 (levels [1]–[4] · [A] · item 2 of [5] · the default in [V] · [D] Data/AI) and PHP (item 16 of [5] · All-in-one) ended as `[실패]` (failed)**. The remove and update lists were fixed too. **With a v1.8.0 or older file these items may fail** (get the file with Option A in [§4](#4-how-to-download)).
- **Added**: `tools/check-winget-ids.ps1` — a check tool that installs nothing and only **looks up whether** every winget name, download address and npm package used in the `.bat` **still exists** (for maintainers · [§15](#15-build--test--release)).
- **Fixed**: after an install finished, the screen showed 2 lines saying `연산자 빠짐` ("operator missing") and the elapsed time always showed `0분 0초` (0 min 0 sec). This display error (unrelated to the install result) is fixed by correcting the elapsed-time formula. **Files from v1.8.0 or older still show it** ([§17](#17-troubleshooting)).
- **Documentation**: the English and Korean READMEs were checked against the code and real lookups — corrected download instructions, a per-tool license table (as looked up), notes on hidden test-only variables, and a cleaned-up list of known issues.
- **Not confirmed**: a **full real install on a new PC** (especially `php -v` for PHP 8.4, and Docker · PostgreSQL · C++ build tools · Android Studio) has not been confirmed. The install call shapes and screen flow were tested on 12 paths with a fake winget.
- **Known issue (not fixed yet)**: the `Failed N` number at the top of the install report **does not include failures of tools installed with npm (Railway CLI, etc.).** A failed tool is shown correctly as `[실패]` (failed) in the list below it, so **use the list as the source of truth** ([§17](#17-troubleshooting)).
</details>

<details>
<summary><b>v1.8.0 (2026-11-15)</b></summary>

- **Added**: main menu **[D] Development environments by field** — Web / Desktop apps / Mobile (→[M]) / Data·AI·Server / Markdown viewer. Pick a field, then only `[Basic]` or `[Everything]`.
- **Added**: **Markdown viewers** — install Obsidian · MarkText · Zettlr **one at a time**. Typora is paid, so only its official page opens; for VS Code only the preview steps are shown.
- **Added**: **Up/Down arrows + Enter (or number)** selection screens (new menus only). If arrows cannot be used it switches to number input automatically, and you can force number-only input with the environment variable `KIT_NO_ARROW=1`.
- **Added**: **C++ build tools** (Visual Studio Build Tools, C++ workload selected) in Desktop [Basic]. Required to build programs with Rust.
- **Added**: **Docker Desktop · PostgreSQL** (Data/AI/Server [Everything]) — warning/consent screens first. The PostgreSQL password is entered hidden and is not stored in the kit's log or report; cautions and troubleshooting are shown afterwards.
- **Added**: accounts that are not in the Administrators group skip only the tools that need admin rights (C++ build tools · Docker · PostgreSQL), with the reason shown.
- **Added**: [9] Check install now lists C++ build tools · Docker · PostgreSQL · Obsidian · MarkText · Zettlr.
- **Added**: **real install verification** ([D] and Markdown viewers): even when winget reports success, the kit checks once more that the tool is really installed, and shows `[확인실패]` (verification failed) instead of counting a success if it cannot.
- **Added**: [6] Update · [7] Remove · [8] Direct download now include Obsidian · MarkText · Zettlr · Docker Desktop · PostgreSQL · C++ build tools. Removing PostgreSQL lets you **choose whether to keep or delete the data**, and the deleting option asks once more.
- **Changed**: after installing Rust via Advanced · All-in-one · [5] item 14, a **one-line note** appears if the C++ build tools are missing (install lists unchanged).
- **Note**: install lists and behavior of levels [1]–[4] · [A] · [M] are unchanged. Installing Docker · PostgreSQL · C++ build tools with the real winget was not tested (system-wide tools); only the install-call shape and screen flow were checked with a fake winget.
</details>

<details>
<summary><b>v1.7.1 (2026-11-14)</b></summary>

- **Fixed**: failed installs that were shown as a red `[건너뜀]` (skipped) — in winget, npm and Claude Code CLI — now show **`[실패]` (failed)**. The report already recorded them as failures, so the screen and the report disagreed.
- **Fixed**: in **every input prompt (35)** — main menu, remove and version select included — pressing just Enter no longer **repeats the previous choice** (e.g. Enter at the main menu re-ran the last menu; Enter in single remove removed the same tool again).
- **Fixed**: added **number validation** to [5] Custom install and [M] Pick items (digits and commas only, in range). Special characters used to freeze the window, a non-existent number could show "install complete", and in [7] single remove a non-existent number showed "remove complete" — all fixed. The finish message no longer says only "install complete" when everything failed.
- **Changed**: **19 yes/no questions can now be answered with numbers** (`1` = yes / `2` = no). The old `y`/`n` still works. Remove/delete prompts say exactly what runs (e.g. `1=Delete / 2=Cancel` in Korean) and pressing just Enter does not run them.
- **Changed**: main-menu and first-screen wording simplified (fewer terms like `winget` / `package manager`; the first screen now mentions **[M]**). "Send it to your instructor" on the finish screen now reads **"to your instructor or someone who helps you"** so solo users understand it.
- **Note**: install lists and install behavior are unchanged (wording and input method only).
</details>

<details>
<summary>v1.7.0 (2026-11-14)</summary>

- **Added**: main menu **[M] Mobile app development** — installs Git · Flutter · **Android Studio** · **adb** · (optional) **scrcpy** in one go: `[1] Mobile basic` / `[2] Basic + scrcpy` / `[3] Pick items` / `[4] After-install guide`. Also available as items 28–30 in [5] Custom install.
- **Added**: a **virtualization check** before installing (informational, never blocks) and a **step-by-step guide** afterwards (first Android Studio launch · license acceptance · `flutter doctor` · USB debugging on the phone). Environment variables are not set; guidance only.
- **Added**: [9] Check install now lists Android Studio · adb · scrcpy and offers an optional **`flutter doctor` summary**. [6] Update, [7] Remove and [8] Direct download include the new tools.
- **Note**: iOS apps cannot be built on Windows (a Mac is required). The install lists of levels [1]–[4] and [A] are unchanged.
</details>

<details>
<summary>v1.6.3 (2026-11-14)</summary>

- **Fixed**: **Flutter installation always failed** — winget has no Flutter package (`Google.FlutterSDK`), so Advanced, All-in-one and [5] item 12 failed every time (including the 5-second retry). The kit now downloads stable from Flutter's official repository (git), checks the first run, and reports success or failure honestly.
- **Changed**: exactly **one** entry is added to the user PATH for Flutter (no duplicates, existing values preserved). [7] Remove only deletes the kit's own location and cleans that PATH entry. Flutter does not need Java, so choosing Flutter in [5] now checks for **Git** first instead of Java.
- **Safeguards**: never overwrites or deletes an existing folder at the install location · includes a setting that avoids Windows long-path (260 character) errors.
</details>

<details>
<summary>v1.6.2 (2026-09-08)</summary>

- Docs only: added sections for environment variables, build/test/deploy and operational notes (no install behavior change).
</details>

<details>
<summary>v1.6.1 (2026-07-22)</summary>

- **Changed**: **scoop is now auto-included in level installs [1]–[4]**. Picking a level also installs scoop (after the level's Y confirmation). Standalone [S] install still available. Counts updated (Beginner 6 · Intermediate 12 · Advanced 17 · All-in-one 19).
- **Note**: [A] Easiest recommended stays as-is (scoop not included).
</details>

<details>
<summary>v1.6.0 (2026-07-22)</summary>

- **Added**: **[S] Install scoop** menu item — a dev package manager. Not in winget, so it uses the official installer (get.scoop.sh) and asks for **consent (Y/N)**. Also added to [9] Check install.
- **Fixed (critical)**: **[5] Custom install installed nothing** — the `!SEL:,= !` (delayed-expansion) loop iterated only once (wrongly) in cmd. Fixed with `%SEL:,= %` + restored the preview `%n`→`%%n` (levels [1]–[4] were unaffected).
- **Security**: scoop is the kit's first remote-script path — official source (HTTPS) only, no signature verification, requires user consent. (see §13)
</details>

<details>
<summary>v1.5.1 (2026-07-22)</summary>

- **Fixed**: issues that appeared when downloading & running the GitHub ZIP on another PC — ① the window closing immediately on launch (kept `.bat` line endings (CRLF) via `.gitattributes`) ② a parsing bug where the pre-check misjudged a healthy Windows as an “old version” and only printed “install winget manually” (cleaned up 28 display parentheses inside `if`/`for` blocks — install logic unchanged)
- **Robust winget detection**: for cases where winget is installed but not detected — on failure, add the WindowsApps path to the session PATH and retry (handles App Execution Alias OFF / missing PATH)
- **Better guidance**: when winget is missing, a **3-step fix** ([8] Direct download as a workaround / install “App Installer” / turn on the “App execution alias”)
</details>

<details>
<summary>v1.5.0 (2026-07-22)</summary>

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
NOTICE                           ← copyright and third-party (installed tools) notice
tools/check-winget-ids.ps1       ← maintainer check tool (only looks things up, installs nothing · not needed by regular users)
PRD/                            ← early planning docs (reference · may differ from the current implementation — e.g. old winget names remain)
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
      · On failure: auto-retry once after 5s → then shown as **[실패] (failed)** (points to [8] Direct download)
  → Post-install setup (Git line-endings, pip upgrade, etc.)
  → Save 2 reports + print PATH check
  → “Open a new terminal to start” message
```

**Mobile ([M]) flow**

```
M → 1 Mobile basic / 2 Basic+scrcpy / 3 Pick items / 4 Guide only
  → [Pre-check] ~10 GB disk · virtualization (informational only, never blocks)
  → Install Git → Flutter → Android Studio → adb → (scrcpy)
  → After-install guide (done by you): first Android Studio launch → accept licenses → flutter doctor → USB debugging on the phone
```

---

## 12. Architecture

- **Single file**: one pure Windows batch script (`.bat`). No separate install/build.
- **Package manager**: **winget** (the official repository run by Microsoft). Each tool comes from its official source, and winget **checks the downloaded installer’s hash against the repository record**.
- **Structure (subroutines)**: menu → `:PRE_CHECK` → `:INSTALL` / `:NPM_INSTALL` (install + retry) → `:POST_*` (post-install) → `:MAKE_REPORTS` → `:PATH_CHECK`.
- **Two exception install paths**: **scoop** (official install script) and **Flutter** (official git repository), kept in dedicated subroutines (`:INSTALL_SCOOP`, `:INSTALL_FLUTTER`) that report `[실패]` (failed) honestly.
- **Mobile menu**: `:DO_MOBILE` (choice) → pre-check → `:INSTALL_MOBILE` → `:POST_MOBILE` (guide). A **separate flow, not mixed into levels [1]–[4].**
- **Input handling**: every prompt clears its variable first, so **pressing just Enter never repeats the previous choice**; numbers in [5], [M]-3 and [7] are **validated** before use (special characters and out-of-range numbers are rejected).
- **PowerShell fragments**: the `.bat` contains PowerShell code (`::PS:` lines = the arrow-key selection screen in [D]; `::PG:` lines = PostgreSQL password entry and install). At run time it reads only those lines and runs them with PowerShell; no separate file is created.
- **Portability**: `%~dp0`-based, so it works even if you rename/move the file.
- **Encoding**: CP949 (for Korean Windows). On English Windows the menu text may look garbled (known limitation — see [14](#17-troubleshooting)).

---

## 13. Security / data flow

- **Existing level installs are attempted without admin rights** (user-scope install). Works on corporate/school PCs. However, **[D]'s C++ build tools · Docker Desktop · PostgreSQL need an administrator account** (only those tools are skipped otherwise).
- **Official source only (winget)**: every winget install uses `--source winget` (the official repository run by Microsoft). winget **checks the installer’s hash against the repository record** (whether each vendor’s own signature is verified differs per tool).
- **Remote-script exception — scoop (1)**: scoop is not in winget, so it runs the official installer (`https://get.scoop.sh`, HTTPS). This is the **only path that downloads an installer script and runs it directly**, and it runs **only during a level install [1]–[4] (after the Y confirmation) or when you pick [S]**. Unlike winget there is no signature verification; only the official source is used.
- **Flutter exception — one git repository**: Flutter is not in winget, so the kit downloads the official repository (`https://github.com/flutter/flutter.git`, HTTPS, stable) with git. The downloaded Flutter tool **fetches the Dart SDK from Google servers on its first run** (no signature verification; official source only). The install location is inside your user folder, so no administrator rights are needed.
- **The mobile tools (Android Studio · adb · scrcpy) all go through winget**, the same signature-verified path as the other tools. **You accept the Android SDK licenses yourself**; the kit never accepts them for you.
- **[D]'s tools also all go through winget** (Obsidian · MarkText · Zettlr · C++ build tools · Docker Desktop · PostgreSQL). The C++ build tools use `--override` to select the components, and PostgreSQL uses `--override` to pass the password.
- **PostgreSQL password handling**: the password is read **hidden** in a PowerShell prompt and handed straight to the installer (winget). **It is not kept in the batch file, the kit log, the report or on screen.** However, the installer may record it in its own logs, and other programs on the same PC can see it on the command line while installing, so **do not reuse a password you use elsewhere.** Only letters and digits are allowed because special characters break the install command.
- **Hidden test variable — be aware**: if the environment variable `KIT_TEST_PGPW` is set, the kit uses its value and skips the password prompt (meant for the kit developer's automated tests). **In normal use it should not be set**, and do not put a real password in it. Details and how to check: [§14](#14-environment-variables).
- **Minimal, validated input**: you type **only menu numbers**. Numbers in [5] and [M] accept digits, commas and the valid range only; anything else is rejected. No path for running arbitrary commands.
- **What the scoop step changes**: when installing scoop, the kit **sets the PowerShell execution policy (current-user scope) to `RemoteSigned`** and runs the official script (the value scoop requires). How to undo: [§14](#14-environment-variables).
- **What is installed via npm**: Claude Code CLI, Railway CLI in the level installs, and any npm tools you answer yes to or pick in [5] (Vercel CLI, etc.) come from the **npm registry, not winget** (npm’s package-integrity checks apply).
- **Privacy**: Git name/email are **only shown, never auto-saved**.
- **The kit sends no data**: the only files created are **local** (report/log); nothing is sent to a server. The network actions the kit itself performs are: (1) one connectivity `ping` (8.8.8.8), (2) calling winget and npm, (3) downloading the official scoop script (`get.scoop.sh`), and (4) fetching the official Flutter repository (`github.com/flutter/flutter`) — all official sources listed above. Any other connection (Dart SDK, Android SDK, etc.) is made by the installed tools themselves.
- **Installed tools’ own traffic**: installed tools (e.g. Flutter, Android Studio, VS Code) may send **usage statistics or check for updates**. That follows each tool’s settings and terms, not the kit.
- **Report contents**: PC name (COMPUTERNAME) and results only. **No username, home path, or passwords.**
- **No secrets**: the code/docs contain no API keys, tokens, or passwords.

---

## 14. Environment variables

**There are no environment variables you need to set.** Download the file and run it. (It does not use a `.env` file either.)

**Optional (advanced):** on a PC where the arrow selection screen looks wrong, set the environment variable `KIT_NO_ARROW=1` to use **number input only** (if arrows cannot be used it also switches to number input by itself).

**Optional (advanced):** if your PostgreSQL data folder is not at the default location (`%ProgramFiles%\PostgreSQL\17\data`), set the environment variable `KIT_PG_DATA_DIR` to that folder. Removal then uses it for the notice and deletion. As a safety check the kit **only deletes a folder named `data` that contains a `PG_VERSION` file**.

**Test-only variables (do not use in normal use)** — hidden hooks the kit developer uses for automated tests. **Not being set is the normal state.**

| Variable | What it does | Caution |
|----------|-------------|---------|
| `KIT_PICK_KEYS` | Replaces the arrow-key selection screens in [D] with **pre-set key presses** (separated by commas) | While set, you cannot choose on screen yourself |
| `KIT_TEST_PGPW` | **Skips the PostgreSQL password prompt** and uses this value (only 8–64 letters/digits are accepted; otherwise it is ignored and the screen asks) | Other programs on the same account can read environment variables, so **do not put a real password here** |

How to check: in Command Prompt, type `set KIT_`. If **nothing is shown, that is normal**. If a value shows up, check that you did not set it yourself, and delete it in the environment variable editor if you do not need it.

**Standard Windows variables the kit only reads**

| Variable | What it is used for |
|----------|--------------------|
| `%USERPROFILE%` | Locating the scoop install (`...\scoop\shims\scoop.cmd`) and the **Flutter install location** (`...\develop\flutter`) |
| `%ProgramFiles%` | Locating Git and Android Studio (when just installed and not yet on PATH) |
| `%ProgramFiles(x86)%` | **Detecting the C++ build tools** (the Visual Studio helper `vswhere`) |
| `%ProgramFiles%\nodejs` | For [D]'s npm tools (Vercel, Supabase): when Node.js was just installed and is not on PATH yet, added to PATH **for this window only** (not saved) |
| `%SCOOP%` | **If you already keep scoop in a custom folder**, that location is used first |
| `%LOCALAPPDATA%` | Stores the marker file that shows the first-run notice only once |
| `%TEMP%` | Temporary work (the temp file for the `flutter doctor` summary is deleted afterwards) |
| `%COMPUTERNAME%` | Records the PC name in the install report |
| `%DATE%` · `%TIME%` | Report/log file names and elapsed-time calculation |

**Settings the kit changes (all reversible)**

| What | Value | Command to undo |
|------|-------|-----------------|
| Git line endings | `core.autocrlf=true` | `git config --global --unset core.autocrlf` |
| Disable npm ads | `fund=false` | `npm config delete fund` |
| Console colours | Registry `HKCU\Console\VirtualTerminalLevel=1` | Delete that registry value |
| PowerShell execution policy (only when installing scoop) | Current-user scope `RemoteSigned` | `Set-ExecutionPolicy Undefined -Scope CurrentUser` (scoop may stop working) |
| User PATH (Flutter only) | **Adds one entry**: `%USERPROFILE%\develop\flutter\bin` | Removing Flutter in [7] cleans it up automatically, or delete that line in the environment variable editor |

> **The kit mostly leaves PATH alone.** Each installer (winget, scoop) registers its own entry. **The one exception is Flutter**: a git-downloaded Flutter has no installer to register it, so the kit adds **only that one entry** to your user PATH (not added if already present; existing entries are preserved).
> That is why commands do not work in the current window right after installing — you must **open a new terminal**. (To notify Windows of the PATH change, the kit **briefly creates and immediately deletes** a user variable named `KIT_PATH_REFRESH`.)
>
> **The kit does not set Android SDK environment variables (`ANDROID_HOME` etc.).** If Flutter reports it cannot find the SDK, run the `flutter config --android-sdk` command shown in the [M] → [4] guide once (it is Flutter's own setting, so no PC setting changes).

---

## 15. Build · test · release

### Build — **none**

It is a single `.bat` file, so there is **no compile or build step.** Run the file exactly as downloaded.
You do not need any development tools or package managers (npm, etc.) beforehand.

### Testing — for users (step by step)

1. Run `dev-one-click-setting-kit.bat`
2. Choose **`[9] Check installation`** → each tool is shown with `[O]`/`[X]` and its version
3. If a tool shows `[O]` but the command still fails → **open a new terminal** and check again
4. If something looks wrong, read the **last line** of `install-log-<date>.txt` in the same folder

### Testing — after changing the code (for developers)

Batch files only reveal syntax errors **at run time**, so always actually run what you changed.

0. **Check first without installing (recommended):** `check-winget-ids.ps1` in the `tools` folder only looks up whether every winget name, download address and npm package used in the `.bat` **still exists**. It installs and changes nothing, and its usage is described at the top of that file. The last line of the result must be `RESULT: PASS`; if even one item shows `[MISSING]`, the result is `FAIL`. `[warn]` means only the letter case differs, which does not affect installing.
1. Copy the modified block into a separate `.bat` and run it in `cmd` → verify both branches and the output
2. Run the whole kit → enter each menu number and confirm there are no error messages
3. Use `[9] Check installation` to confirm nothing existing broke
4. **Test bad input too**: empty input (just Enter), non-existent numbers, special characters (`&` `(` `"` `%`), very long input.

> ⚠️ **Do not just run the install flows on your own PC.** A level install runs the scoop official script and changes the PowerShell execution policy, and `[A]` opens browser windows. To test install/remove flows, **put fake `winget`/`npm`/`scoop` executables first on PATH** and point `USERPROFILE`/`LOCALAPPDATA` at temporary folders to isolate them. Do not push several input lines at once — send them **one line at a time after each question appears** (a batch prompt does not reliably accept bulk line input).

### Release — for maintainers

1. Run `tools\check-winget-ids.ps1` and confirm **`RESULT: PASS`** (if a winget name no longer exists, fix it before releasing)
2. Add the changes to `CHANGELOG.md`
3. Update the version number in the comment at the top of the `.bat`
4. Commit the changes → PR → merge into `main`
5. GitHub **Releases → Draft a new release** → set a tag (e.g. `v1.8.2`) → **attach `dev-one-click-setting-kit.bat` under Assets** (**do not forget this** — v1.8.0 was released without the attachment)
6. Just before attaching, confirm the file is **byte-identical to the one in the repository** (CP949 and CRLF preserved). Do **not move an already published tag to a different commit** (it would no longer match the file people downloaded earlier) — if something needs fixing, publish a new version.

> ⚠️ **Never delete the `*.bat -text` line in `.gitattributes`.**
> Without it, downloading the ZIP from GitHub converts the `.bat` line endings to LF and **the window closes the instant you run it.** (This was a real bug fixed in v1.5.1.)

---

## 16. Operational notes

- **Open a new terminal after installing.** The existing window predates the install and cannot find the commands.
- **Do not close the window during installation.** If a download is interrupted, only that tool fails (rerunning picks up where it left off).
- **Running it repeatedly is safe.** Anything already installed defaults to "skip".
- **Work and school PCs** often block winget by policy → use `[8] Direct download`; if that also fails, contact your IT administrator (it is a permissions issue a user cannot resolve).
- **Antivirus software may block the `.bat`.** Confirm the file came from the official repository, then add it to the allow list.
- **Log and report files** accumulate by date on every run. Delete them if you do not need them (they are in `.gitignore`, so they never reach the repository).
- **When sending a report to someone**, just be aware it contains your PC name. It contains no passwords or personal file information.
- **Flutter is installed to `%USERPROFILE%\develop\flutter`.** If a different folder already exists there, the kit does not overwrite it and reports a failure. Flutter's docs recommend a path **without spaces or special characters**, and the first run downloads the Dart SDK (hundreds of MB), which takes a few minutes.
- **The mobile environment ([M]) is large.** About 10 GB of disk and 30–40 minutes; Android Studio **downloads the SDK on its first launch**. The Android emulator is fast only with virtualization enabled; a real phone over USB works without it.
- **scoop is installed automatically with the level installs** (it is in the list shown at the start). If you do not want it, use [5] Custom install.
- **On English (non-Korean) Windows** the menu text may appear garbled (known limitation).

---

## 17. Troubleshooting

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| Blue SmartScreen window | Windows protection | **[More info] → [Run anyway]** (normal) |
| Only Python 3 or PHP shows `[실패]` (failed) | An old file (v1.8.0 or older) uses names (`Python.Python.3`, `PHP.PHP`) that no longer exist in the winget repository | Get the latest file with **Option A (ZIP)** in [§4](#4-how-to-download) and run it again. If you are in a hurry, **pick** `1` (3.13) for Python in **[V]**, and use **[8] Direct download** for PHP |
| After the install finishes, 2 lines saying `연산자 빠짐` ("operator missing") appear and the elapsed time shows `0분 0초` (0 min 0 sec) | An error in the formula that calculates the elapsed time | **You can ignore it.** It does not affect whether installs are judged a success or failure; only the elapsed-time value in the log and report is wrong. **It is fixed from v1.8.1**, so if you see it your file is old — get the latest file from [§4](#4-how-to-download) ([§9](#9-changelog-summary)) |
| The top of the report says `Failed: 0` but the list below has a `[실패]` line | Failures of tools installed with npm (Railway CLI, etc.) are not counted in the top number (a known issue) | **The `[실패]` line in the list is the accurate one.** Check your internet, then run the kit again (tools that already succeeded are skipped) |
| PHP installed, but `php -v` does not work in a new terminal | PHP 8.4 is installed as a zip package, so registering the command may be late or may not happen (not confirmed with a real install on this PC) | Open a new terminal and check again → if it still fails, look at the state with **[9] Check install**, and if that does not help, install it with **[8] Direct download** |
| `winget not found` | App Installer missing | Install **“App Installer”** from Microsoft Store, or https://aka.ms/getwinget |
| Window closes suddenly mid-install | An error occurred | Check the **last line** of `install-log-DATE.txt` in the same folder |
| Only a specific tool fails | Network/policy/winget hiccup | It auto-retries once; if still failing, use **[8] Direct download** |
| Only Flutter fails | No Git · network · a folder already exists at the install location | Follow the reason shown (install Git / rename the folder) and rerun. If it still fails, use **[8] Direct download** |
| A hint like “enter digits 1 to 30 only…” appears | Non-digit/non-comma characters or an out-of-range number in [5]/[M] | Enter **digits and commas only**, e.g. `1,3,6` |
| `adb server version doesn't match` message | adb exists in two places (kit-installed + inside Android Studio) with different versions | Type `adb kill-server`, then try again |
| Fails even as admin | Antivirus blocks the `.bat` | Add it to the allowlist, or briefly disable real-time protection and retry |
| **Menu text looks garbled** | **English (non-Korean) Windows** | Fine on Korean Windows. On English Windows this is a known limitation (a PowerShell launcher is planned) |
| `flutter doctor` shows Android warnings/errors | Android Studio not yet launched · licenses not accepted · SDK location | Follow **[M] → [4]**: launch Android Studio once → `flutter doctor --android-licenses` → `flutter config --android-sdk` if needed |
| [D] arrows do not move or the screen looks odd | The arrow screen does not suit some consoles | You can **type a number and press Enter** instead (it may switch to number input by itself). If it stays odd, set the environment variable `KIT_NO_ARROW=1` |
| C++ build tools · Docker · PostgreSQL were not installed | Not an administrator account | Sign in with an administrator account and run [D] again (skipped tools are named on screen) |
| `cargo build` fails with Rust (`link.exe` not found) | C++ build tools are missing | Install them from **[D] → Desktop apps** (a PC restart may be needed afterwards) |
| After installing, `[확인실패]` (verification failed) or "could not confirm" appears | It is not visible yet right after installing, or it was not really installed | Open a **new terminal** and recheck with main menu [9] Check install. If it still shows X, read `install-log-date.txt` and use [8] Direct download |
| Forgot the PostgreSQL password | Recovering it means editing a config file, hard for beginners | For practice use, uninstall PostgreSQL in Windows Settings → Apps and reinstall it from [D] |
| Low-disk warning | Not enough free space | Free up space and rerun (levels need 3/4/6/7 GB, mobile [M] about 10 GB) |

> When reporting an error, attach `install-log-DATE.txt` instead of a screenshot — it makes diagnosis easier. (No sensitive info inside.)

---

## 18. FAQ

**Q. I’ve never coded — can I use it?**
Yes. Just pressing **[A]** or **[1]** sets up a basic environment.

**Q. Is it safe to run again?**
Yes. Already-installed tools default to **skip**, so it’s safe.

**Q. Do I really need admin rights?**
Usually no. It guides you to admin only when a tool fails.

**Q. Can I install a specific version (e.g., Python 3.11)?**
Yes — via **[V] Version-select install**, stable versions only.

**Q. Can I also build mobile (Android) apps?**
Yes. In the main menu **[M] Mobile app development**, install Flutter, Android Studio and adb in one go, then follow the **after-install steps** shown on screen. iOS apps cannot be built on Windows (a Mac is required).

**Q. How do I answer yes/no questions?**
Type `1` (yes) or `2` (no); the old `y`/`n` still works. **Pressing just Enter does not run anything.**

**Q. Can I try building apps without a phone?**
Yes — with Android Studio’s **virtual phone (emulator)**. It is fast only if **virtualization** is on in your PC; otherwise it may be slow or not work. A real phone over USB works without virtualization.

**Q. I already have Flutter or Android Studio — can I still use [M]?**
Yes. Anything already present is **skipped**. For Flutter, if a **different folder already exists** at the kit location (`%USERPROFILE%\develop\flutter`), the kit **does not overwrite it and reports a failure.**

**Q. Can I build iPhone (iOS) apps?**
No. Building iOS apps **requires a Mac**, so it cannot be done on Windows. This kit prepares Android.

**Q. How do I remove what I installed?**
**[7] Remove** → single or all.

**Q. Is internet required?**
Yes. winget downloads the tools from the internet.

**Q. Does it work on macOS/Linux?**
No. **Windows only.**

**Q. Where do I get the file? There is no file in Releases.**
The v1.8.0 Release had no `.bat` file attached. The latest **v1.8.1 Release has it.** Use **Option A (ZIP)** in [§4](#4-how-to-download) or the file from the v1.8.1 (or later) Release.

**Q. Which versions of Python and PHP get installed?**
Python **3.13** and PHP **8.4**. Other Python versions (3.11/3.12) can be picked in **[V]**. Details are in [§3](#3-programs-installed-tool-list).

**Q. The install finished but I see the text `연산자 빠짐` ("operator missing"). Did it fail?**
No. It is a display error in the part that calculates the elapsed time and has nothing to do with the install result. **It is fixed from v1.8.1**, so if you see it your file is old. See [§17](#17-troubleshooting).

**Q. Is it OK to trust and run this file?**
The `.bat` is a **plain text file you can open and read with Notepad** (right-click → Notepad). The kit downloads tools only from official sources (winget, etc.) and does not send personal information to any server (details in [§13](#13-security--data-flow)). Still, this kit comes **AS-IS, with no warranty**, so on a work or school PC, ask your security administrator first.

**Q. Can I use it at work or in class? Do I have to pay?**
The kit itself is **free**, and because it is Apache 2.0, commercial use is allowed within the conditions. However, **the tools it installs have their own terms**, and some (for example Docker Desktop for business use at larger companies, and Typora) may have conditions or costs. See [§19](#19-legal--copyright--license--commercial-use).

---

## 19. Legal / copyright / license / commercial use

> **Notice (disclaimer):** This section is **general information for reference only** and **does not constitute legal advice or guarantee any legal effect.** For important decisions (commercial distribution, redistribution, etc.), **consult a qualified professional such as a lawyer.**

**At a glance (plain words)**

| What you want to do | Allowed? | What you must keep to |
|--------------------|:-------:|-----------------------|
| **Just use it** at home, work or school | Yes | Installed tools follow their own terms |
| **Modify · copy · fork** | Yes | **Mark changed files as changed**; keep copyright and license notices |
| **Redistribute** (including handing it to students or using it as teaching material) | Yes | Give the **LICENSE copy** along with it and do not remove the copyright/license header at the top of the `.bat` |
| **Sell it · include it in a paid service · deliver it to a company/client** | Yes, within the Apache 2.0 conditions | Installed tools have separate licenses. **Do not make new “warranty” promises** (this kit comes with no warranty). For contract-bound delivery, **legal review is recommended** |
| **Use the “SoDam AI Studio” name/logo as your own product name** | **Not permitted** | You may only state the **origin truthfully**, e.g. “based on SoDam AI Studio’s kit” |
| **Say this kit’s license (Apache 2.0) also covers the tools it installs** | **Must not** | Each tool has its own license |
| **Claim an official partnership, sponsorship or endorsement** by Google, Microsoft, Anthropic, etc. | **Must not** | This kit is an independent tool |

**What you must check yourself**

- The license/terms of each installed tool — especially the **Android SDK license acceptance**, **Claude Code (Anthropic terms and pricing)** and the **VS Code build terms**
- The **pricing and model-usage policies of the AI services/APIs you use**, **external service terms** (Vercel, Supabase, Stripe, etc.) and the **per-model licenses of AI models** downloaded with Ollama
- The license of any **fonts, images, icons, audio or video** you put into your own project (none are included in this repository)
- **Personal-data handling** and **app-store terms** for the apps you build

**What you must not do**

- Anything marked “Not permitted / Must not” in the table above
- Posting **other people’s personal data, non-public material, client information or internal documents** in this repository’s docs, screenshots, issues or PRs
- Posting **reports or logs publicly as-is** (reports contain your PC name)

**1) License of this kit (code/docs)**

- **Apache License 2.0** — Copyright © 2026 **SoDam AI Studio**. Full text: [LICENSE](./LICENSE) (the official Apache 2.0 text; **only the appendix copyright line** is filled in with “SoDam AI Studio”); copyright and third-party notice: [NOTICE](./NOTICE). The same copyright/license header is at the top of the `.bat`, so **the license notice travels even if you distribute the single file.**
- Permits: **free use, modification, distribution, and commercial use.**
- Conditions: on distribution, **include a copy of the license**, **state changes**, keep copyright notices.
- Limitation: **no trademark rights** granted (do not use the “SoDam AI Studio” name/logo without permission).
- Warranty: **AS-IS, no warranty** — the authors are not liable for damages from use (Apache 2.0 §7–8).

**2) Licenses of the “third-party tools” this kit installs (important)**

- This kit does **not redistribute** any tool; it merely **downloads and installs each tool’s official build via winget (or the official repository, official script, or npm).**
- Each installed tool is governed by **its own license and terms.** This kit’s Apache 2.0 **does not apply to the installed tools.**
- **For commercial use / redistribution, you must review and comply with each tool’s license separately.**

The table below is for **reference only**. The values are copied as-is from what was **looked up on 2026-11-20 from the winget manifests (`winget show`) and from npm (`npm view`)**, together with the version at lookup time. **Terms can change, so always check each tool's official license document.**

| Tool | Installed via | Version at lookup | License label (as looked up) | Plain-language note |
|------|--------------|:-----------------:|-----------------------------|---------------------|
| Git | winget | 2.56.0.4 | GPL-2.0 |  |
| Git LFS | winget | 3.8.0 | MIT License |  |
| Python 3.13 / 3.12 / 3.11 | winget | 3.13.17 / 3.12.10 / 3.11.9 | PSF-2.0 |  |
| Node.js LTS | winget | 26.13.1 | MIT |  |
| VS Code | winget | 1.146.0 | Microsoft Software License | The source is MIT, but the **installed build is under Microsoft's terms**. Check those terms |
| Windows Terminal | winget | 1.25.3131.0 | MIT |  |
| GitHub CLI | winget | 2.105.0 | MIT |  |
| PowerShell 7 | winget | 7.7.0.0 | MIT |  |
| pnpm | winget | 12.18.0 | MIT |  |
| Bun | winget | 1.4.5 | MIT |  |
| Ollama | winget | 0.40.16 | MIT | **AI models you download have their own licenses** |
| Java (Eclipse Temurin 21 / 17 / 11 / 8) | winget | 21.0.13.9 / 17.0.21.9 / 11.0.33.10 / 8.0.512.9 | GPL-2.0 with Classpath Exception |  |
| Go | winget | 1.27.4 | BSD-3-Clause |  |
| Rust (rustup) | winget | 1.29.3 | Apache-2.0 or MIT |  |
| Stripe CLI | winget | 1.55.13 | Apache-2.0 |  |
| Ruby (RubyInstaller + DevKit 3.3 / 3.2) | winget | 3.3.13-1 / 3.2.11-1 | BSD-3-Clause | This is the **installer's** (RubyInstaller) label. Check Ruby's own license separately |
| PHP 8.4 | winget | 8.4.27 | PHP License v3.01 |  |
| uv | winget | 0.13.9 | Apache-2.0 or MIT |  |
| Android Studio | winget | 2026.2.2.9 | Android Software Development Kit License Agreement | **You accept the SDK license yourself** (`flutter doctor --android-licenses`) |
| adb (Android Platform-Tools) | winget | 37.0.3 | Apache-2.0 | That is the winget label; **also check the Android SDK terms** |
| scrcpy | winget | 5.0.1 | Apache-2.0 |  |
| Obsidian | winget | 1.15.1 | Proprietary | **Proprietary software**. Check the official terms of use |
| MarkText | winget | 0.23.0 | MIT |  |
| Zettlr | winget | 4.10.0 | GPL-3.0 |  |
| Docker Desktop | winget | 4.99.0 | Proprietary | **Proprietary (Docker subscription terms)**. Free for personal/learning use, but **business use at larger companies may require a paid plan** |
| PostgreSQL 17 | winget | 17.12-2 | PostgreSQL |  |
| Microsoft C++ Build Tools (Visual Studio Build Tools) | winget | 17.14.45 | Proprietary | You **accept Microsoft's terms** during installation |
| Flutter · Dart | official repository (git) | stable | BSD-3-Clause | Value checked on the official GitHub repository on 2026-11-14 (not part of this lookup) |
| scoop | official script (get.scoop.sh) | - | **Not verified** | **Not verified** - check its official repository |
| Typora | not installed (opens the official page only) | - | Paid proprietary | **Paid proprietary software**. Check its official terms (not verified automatically) |
| Claude Code CLI | npm (`@anthropic-ai/claude-code`) | - | SEE LICENSE IN README.md | **Anthropic's commercial terms** apply. Check the service terms and pricing |
| Vercel CLI | npm (`vercel`) | - | Apache-2.0 |  |
| Supabase CLI | npm (`supabase`) | - | MIT |  |
| Stripe SDK | npm (`stripe`) | - | MIT |  |
| Resend SDK | npm (`resend`) | - | MIT |  |
| Railway CLI | npm (`@railway/cli`) | - | ISC |  |
| Clerk | npm (`@clerk/clerk-sdk-node`) | - | MIT |  |
| Prisma | npm (`prisma`) | - | Apache-2.0 |  |
| Uploadthing | npm (`uploadthing`) | - | MIT |  |

> **Verification status (2026-11-20):** The `winget` rows show the **license label in the winget manifest**; the `npm` rows show the result of **`npm view <package> license`**. These labels are **what the package publisher wrote**, they do not replace the full terms, and **they can change when the version changes.** **Not looked up:** scoop; Flutter and Dart (the label checked on the official GitHub repository on 2026-11-14 is kept); Typora (not installed); the Claude Code CLI (its npm label is "SEE LICENSE IN README.md", so read Anthropic's terms yourself). **Check each official document yourself before installing or redistributing.**

**3) Trademarks and affiliation**

- Names and logos such as Android, Google, Flutter, Git, Python, Node.js, Visual Studio Code, Microsoft, Visual Studio, Docker, PostgreSQL, Obsidian, Typora, Rust and Claude (Anthropic) are **trademarks of their respective owners.** This kit is an **independent tool with no affiliation, sponsorship or endorsement** from those companies or projects.
- The “SoDam AI Studio” name/logo is not licensed for use under Apache 2.0 (no trademark rights granted).

**4) Checklist for commercial use**

- To **distribute this kit at a company or in a class**: include the LICENSE copy · state changes · keep copyright notices (Apache 2.0).
- To **use the installed tools for commercial product development**: check **each tool’s terms** in the table above (especially Android SDK, Claude Code and the VS Code build).
- The copyright/license of **the apps/outputs you make** is your responsibility. For **AI-generated code**, check the AI service’s terms (ownership, usage limits).
- **Publishing to app stores** (Google Play, etc.) follows each store’s developer terms. iOS (App Store) requires **a Mac and Apple’s developer terms.**
- If your app handles personal data, review the applicable **privacy laws** separately (in Korea: the Personal Information Protection Act).

**5) Notes on use**

- winget installs come from the **official winget repository.** The exceptions are scoop (official script), Flutter (official repository) and npm tools (npm registry), listed in [§13](#13-security--data-flow). The kit does not send your data anywhere.
- Responsibility for final installation and use rests with **the user.**

**6) Disclosure of AI-assisted authoring**

- Parts of this repository’s code and documents were **written or edited with the help of an AI tool (Anthropic Claude)** (many commits carry a co-author trailer).
- The **copyright ownership and protection scope of AI-generated output, and the possibility that it resembles existing works,** are interpreted differently by country and case — **legal/expert review needed.**
- The same applies to **your own output** made with AI coding using this kit. **Before publishing, selling or delivering it, check the copyright, sources, commercial-use permission and the possibility of infringing similar works yourself.**

**7) External material and sample data in this repository**

- This repository **contains no images, icons, fonts, audio, video, sample accounts or customer data** (checked 2026-11-14; there are no dependency files). Email addresses in the docs, such as `your@email.com`, are **fictional examples.**
- When editing the docs, do not add **other people’s works, screenshots (showing a PC name, username or path), personal data or non-public material.**
- The `PRD/` folder holds **early planning documents**, was generated with an AI tool and may differ from the current implementation. It is under the same license (Apache 2.0) as the rest of the repository.

**8) When you send changes or suggestions**

- Changes or suggestions you submit to this repository are **treated as provided under the Apache 2.0 terms unless agreed otherwise** (Apache 2.0 §5).

**9) Items needing legal/expert review**

- Liability scope and warranty wording when this kit is **included in contract-bound delivery or a paid service**
- Copyright ownership and protection scope of **AI-assisted output**
- **Commercial-use terms of the installed tools** (especially the Android SDK, Claude Code, the VS Code build and Ollama models)
- Apps/services handling **personal data** (in Korea: the Personal Information Protection Act) and the laws of each country for **overseas distribution**

---

<sub>By SoDam AI Studio · License: Apache License 2.0 · Windows only</sub>
