@echo off
chcp 949 >nul
setlocal enabledelayedexpansion

:: ============================================================
:: ¹ÙÀÌºêÄÚµù È¯°æ Å°Æ® -- DEV-KIT.bat v1.8.0
:: AI ¹ÙÀÌºêÄÚµù ÀÔ¹®ÀÚ¸¦ À§ÇÑ ¿øÅ¬¸¯ °³¹ß È¯°æ ¼¼ÆÃ µµ±¸
:: ============================================================

:: ============================================================
:: Dev_One-Click_Setting_Kit - dev-one-click-setting-kit.bat
:: Copyright 2026 SoDam AI Studio
:: SPDX-License-Identifier: Apache-2.0
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::     https://www.apache.org/licenses/LICENSE-2.0
:: Provided on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND.
:: This kit does not include third-party software. It only installs tools from
:: their official sources; each installed tool is under its own license and terms.
:: ÀÌ Å°Æ®°¡ ¼³Ä¡ÇÏ´Â µµ±¸´Â °¢ÀÚÀÇ ¶óÀÌ¼±½º¿Í ¾à°üÀ» µû¸¨´Ï´Ù.
:: LICENSE / NOTICE / README: https://github.com/sodam-ai/Dev_One-Click_Setting_Kit
:: ============================================================

:: ³¯Â¥ º¯¼ö (PowerShell·Î ·ÎÄÉÀÏ µ¶¸³Àû Ã³¸®)
for /f %%d in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd" 2^>nul') do set REPORT_DATE=%%d
if not defined REPORT_DATE set REPORT_DATE=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%

set REPORT_FILE=%~dp0install-report-%REPORT_DATE%.txt
set LOG_FILE=%~dp0install-log-%REPORT_DATE%.txt
set START_TIME=%TIME%
set UPGRADE_MODE=skip
set "KIT_SELF=%~f0"
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"

:: Enable ANSI color sequences (Windows 10+)
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

:: ·Î±× ÆÄÀÏ ÃÊ±âÈ­
> "%LOG_FILE%" echo === ¹ÙÀÌºêÄÚµù È¯°æ Å°Æ® ¼³Ä¡ »ó¼¼ ·Î±× ===
>> "%LOG_FILE%" echo ½ÃÀÛ: %DATE% %TIME%
>> "%LOG_FILE%" echo.

:: Welcome screen: show only on first run (skip to menu afterwards)
if exist "%LOCALAPPDATA%\devkit_intro_seen" goto MAIN_MENU
cls
echo.
echo  ===========================================================
echo    Ã³À½ ¿À¼Ì³ª¿ä? 30ÃÊ¸¸ ÀÐ¾îÁÖ¼¼¿ä.
echo  ===========================================================
echo.
echo   - ÀÌ ÇÁ·Î±×·¥Àº ÄÚµù¿¡ ÇÊ¿äÇÑ µµ±¸µéÀ» ÀÚµ¿À¸·Î ¼³Ä¡ÇØ ÁÝ´Ï´Ù.
echo   - ¹øÈ£¸¦ °í¸£±â Àü¿¡´Â ¾Æ¹«°Íµµ ¼³Ä¡µÇÁö ¾ÊÀ¸´Ï ¾È½ÉÇÏ¼¼¿ä.
echo   - ¼³Ä¡ Áß ÆÄ¶õ °æ°íÃ¢[Windows°¡ PC¸¦ º¸È£Çß½À´Ï´Ù]ÀÌ ¶°µµ Á¤»óÀÔ´Ï´Ù.
echo     ±×·² ¶© [Ãß°¡ Á¤º¸] ¸¦ ´©¸¥ µÚ [½ÇÇà] À» ´©¸£¸é µË´Ï´Ù.
echo   - ÀÎÅÍ³ÝÀ¸·Î ¹Þ±â ¶§¹®¿¡ ½Ã°£ÀÌ Á» °É·Áµµ Ã¢À» ´ÝÁö ¸¶¼¼¿ä.
echo   - Ã³À½ÀÌ¶ó¸é ¸Þ´º¿¡¼­ [A] °¡Àå ½¬¿î ÃßÃµ ¼³Ä¡ ¸¦ ´©¸£¼¼¿ä.
echo   - Æù ¾ÛÀ» ¸¸µé°í ½Í´Ù¸é [M] ¸ð¹ÙÀÏ ¾Û °³¹ß À» ´©¸£¼¼¿ä.
echo   - À¥ / µ¥½ºÅ©Åé / ¼­¹ö °³¹ß È¯°æ°ú ¸¶Å©´Ù¿î ºä¾î´Â [D] ¸¦ ´©¸£¼¼¿ä.
echo   - ¿¹/¾Æ´Ï¿À Áú¹®Àº ¼ýÀÚ 1 [¿¹] ¶Ç´Â 2 [¾Æ´Ï¿À] ·Î ´äÇÏ¸é µË´Ï´Ù.
echo.
echo   - ¸ðµç µµ±¸´Â º£Å¸°¡ ¾Æ´Ñ '¾ÈÁ¤ ¹öÀü', Node¿Í Java´Â 'LTS(¿À·¡ Áö¿øµÇ´Â ¾ÈÀüÆÇ)'·Î ¼³Ä¡µË´Ï´Ù.
pause
>"%LOCALAPPDATA%\devkit_intro_seen" echo seen 2>nul
:MAIN_MENU
cls
echo.
echo  ===========================================================
echo    [96m¹ÙÀÌºêÄÚµù È¯°æ Å°Æ® ^| AI °³¹ß È¯°æ ¿øÅ¬¸¯ ¼¼ÆÃ[0m
echo  ===========================================================
echo.
echo    [1] ¿ÕÃÊº¸ ¼³Ä¡    Ã³À½ ½ÃÀÛÇÏ´Â ºÐ  (6°³,  ~7ºÐ)
echo    [2] Áß±Þ ¼³Ä¡      ¾î´À Á¤µµ ½áº» ºÐ (12°³, ~15ºÐ)
echo    [3] °í±Þ ¼³Ä¡      ¾Û/¼­¹ö °³¹ßÇÏ´Â ºÐ(17°³, ~35ºÐ)
echo    [4] ¿ÃÀÎ¿ø ¼³Ä¡    ¸ðµç µµ±¸ ¼³Ä¡    (19°³, ~45ºÐ)
echo    ---------------------------------------------------
echo    [5] ¼±ÅÃ ¼³Ä¡      ¿øÇÏ´Â °Í¸¸ °ñ¶ó¼­
echo    [6] ¾÷µ¥ÀÌÆ®       ¼³Ä¡µÈ µµ±¸ ÀüÃ¼ ÃÖ½ÅÀ¸·Î
echo    [7] Á¦°Å           µµ±¸ »èÁ¦ (°³º°/ÀüÃ¼)
echo    [8] Á÷Á¢ ´Ù¿î·Îµå  ÀÚµ¿ ¼³Ä¡°¡ ¾È µÉ ¶§ °ø½Ä »çÀÌÆ®¿¡¼­ Á÷Á¢ ¹Þ±â
echo    [9] ¼³Ä¡ È®ÀÎ      Àß ±ò·È´ÂÁö O/X ·Î È®ÀÎ + ¹öÀü Ç¥½Ã
echo    [0] Á¾·á
echo.
echo  ===========================================================
echo    [A] °¡Àå ½¬¿î ÃßÃµ ¼³Ä¡   Ã³À½ÀÌ¸é ÀÌ°Å [±âº» 5Á¾ + AI µµ±¸]
echo    [V] ¹öÀü ¼±ÅÃ ¼³Ä¡        ¿øÇÏ´Â ¹öÀüÀ¸·Î ¼³Ä¡ [Python/Java/Ruby]
echo    [S] scoop ¼³Ä¡            ÇÁ·Î±×·¥ ¼³Ä¡¸¦ µµ¿ÍÁÖ´Â µµ±¸ [³ªÁß¿¡ ÇÊ¿äÇÒ ¶§]
echo    [M] ¸ð¹ÙÀÏ ¾Û °³¹ß        Æù ¾Û ¸¸µé±â È¯°æ [Flutter, Android Studio]
echo    [D] ºÐ¾ßº° °³¹ß È¯°æ      À¥ / µ¥½ºÅ©Åé / ¼­¹ö / ¸¶Å©´Ù¿î ºä¾î
set MENU_CHOICE=
set /p MENU_CHOICE="  ¹øÈ£¸¦ ÀÔ·ÂÇÏ¼¼¿ä: "

if /i "!MENU_CHOICE!"=="A" goto DO_EASY
if /i "!MENU_CHOICE!"=="V" goto DO_VERSION
if /i "!MENU_CHOICE!"=="S" goto DO_SCOOP
if /i "!MENU_CHOICE!"=="M" goto DO_MOBILE
if /i "!MENU_CHOICE!"=="D" goto DO_DEV
if "!MENU_CHOICE!"=="1" goto DO_LEVEL_1
if "!MENU_CHOICE!"=="2" goto DO_LEVEL_2
if "!MENU_CHOICE!"=="3" goto DO_LEVEL_3
if "!MENU_CHOICE!"=="4" goto DO_LEVEL_4
if "!MENU_CHOICE!"=="5" goto DO_SELECT
if "!MENU_CHOICE!"=="6" goto DO_UPDATE
if "!MENU_CHOICE!"=="7" goto DO_REMOVE
if "!MENU_CHOICE!"=="8" goto DO_MANUAL
if "!MENU_CHOICE!"=="9" goto DO_CHECK
if "!MENU_CHOICE!"=="0" goto DO_EXIT
goto MAIN_MENU

:: ============================================================
:: »çÀü Ã¼Å© (°øÅë)
:: È£Ãâ Àü PRE_CHECK_RETURN º¯¼ö¿¡ º¹±Í ·¹ÀÌºí ¼³Á¤
:: ============================================================
:PRE_CHECK
echo.
echo  [»çÀü Ã¼Å©] ¼³Ä¡ È¯°æÀ» È®ÀÎÇÕ´Ï´Ù...
echo.
>> "%LOG_FILE%" echo.
>> "%LOG_FILE%" echo === »çÀü Ã¼Å©: %TIME% ===

:: 1. Windows ¹öÀü È®ÀÎ (ºôµå 19044 = Win10 21H2)
:: delims=. À¸·Î "10.0.22631.xxx" ÀÇ ¼¼ ¹øÂ° ÅäÅ«(ºôµå¹øÈ£)¸¸ ÃßÃâ
for /f "tokens=3 delims=." %%a in ('ver') do set WIN_BUILD=%%a
if defined WIN_BUILD (
    if !WIN_BUILD! LSS 19044 (
        echo  [ÁÖÀÇ] Windows 10 ¿À·¡µÈ ¹öÀü °¨Áö [ºôµå: !WIN_BUILD!]
        echo         winget ¼öµ¿ ¼³Ä¡: https://aka.ms/getwinget
        echo.
        >> "%LOG_FILE%" echo ÁÖÀÇ: Windows ºôµå !WIN_BUILD! - winget ºÒ¾ÈÁ¤ °¡´É
        set CONT_WIN=
        set /p CONT_WIN="  °è¼Ó ÁøÇàÇÏ½Ã°Ú½À´Ï±î? 1=¿¹ / 2=¾Æ´Ï¿À: "
        if "!CONT_WIN!"=="1" set CONT_WIN=y
        if /i "!CONT_WIN!" NEQ "y" goto MAIN_MENU
    ) else (
        echo  [OK] Windows ºôµå !WIN_BUILD!
        >> "%LOG_FILE%" echo OK: Windows ºôµå !WIN_BUILD!
    )
)

:: 2. winget È®ÀÎ
:: 2. winget È®ÀÎ (¿©·¯ °æ·Î·Î °ß°íÇÏ°Ô °¨Áö)
set "WINGET_OK="
winget --version >nul 2>&1 && set "WINGET_OK=1"
:: PATH ¿¡¼­ WindowsApps °¡ ºüÁ³À» ¼ö ÀÖÀ¸´Ï ¼¼¼Ç PATH ¿¡ Ãß°¡ ÈÄ Àç½Ãµµ
if not defined WINGET_OK if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\winget.exe" (
    set "PATH=%LOCALAPPDATA%\Microsoft\WindowsApps;%PATH%"
    winget --version >nul 2>&1 && set "WINGET_OK=1"
)
if not defined WINGET_OK (
    echo.
    echo  [¿À·ù] winget[¾Û ¼³Ä¡ °ü¸®ÀÚ]À» ½ÇÇàÇÒ ¼ö ¾ø½À´Ï´Ù.
    echo.
    echo   [ÇØ°á ¹æ¹ý - ¾Æ·¡ Áß ÇÏ³ª¸¸ ÇÏ¸é µË´Ï´Ù]
    echo.
    echo   ¹æ¹ý 1. ÀÌ Ã¢À» ´Ý°í, ¸ÞÀÎ ¸Þ´º¿¡¼­ [8] Á÷Á¢ ´Ù¿î·Îµå ·Î
    echo           ÇÊ¿äÇÑ µµ±¸¸¦ °ø½Ä »çÀÌÆ®¿¡¼­ ¹Ù·Î ¹ÞÀ¸½Ç ¼ö ÀÖ½À´Ï´Ù.
    echo.
    echo   ¹æ¹ý 2. Microsoft Store ¿¡¼­ "¾Û ¼³Ä¡ °ü¸®ÀÚ" ¸¦ ¼³Ä¡/¾÷µ¥ÀÌÆ®ÇÑ µÚ
    echo           ÀÌ ÇÁ·Î±×·¥À» ´Ù½Ã ½ÇÇàÇÏ¼¼¿ä.
    echo           [½ºÅä¾î ¸µÅ©] https://aka.ms/getwinget
    echo.
    echo   ¹æ¹ý 3. ¼³Á¤ - ¾Û - °í±Þ ¾Û ¼³Á¤ - ¾Û ½ÇÇà º°Äª ¿¡¼­
    echo           "¾Û ¼³Ä¡ °ü¸®ÀÚ" ¸¦ ÄÒ µÚ ´Ù½Ã ½ÇÇàÇÏ¼¼¿ä.
    echo.
    >> "%LOG_FILE%" echo ¿À·ù: winget ½ÇÇà ºÒ°¡
    pause
    goto MAIN_MENU
)
for /f %%v in ('winget --version') do set WINGET_VER=%%v
echo  [OK] winget !WINGET_VER!
>> "%LOG_FILE%" echo OK: winget !WINGET_VER!
:: °ü¸®ÀÚ ±ÇÇÑ È®ÀÎ (½ÇÆÐÇØµµ °è¼Ó ÁøÇà)
net session >nul 2>&1
if errorlevel 1 (
    echo  [¾È³»] °ü¸®ÀÚ ±ÇÇÑÀÌ ¾Æ´Õ´Ï´Ù. ´ëºÎºÐ ±×´ë·Î ¼³Ä¡µÇÁö¸¸,
    echo         ÀÏºÎ µµ±¸°¡ ¾È µÇ¸é ÀÌ ÆÄÀÏÀ» ¸¶¿ì½º ¿ìÅ¬¸¯ ÈÄ "°ü¸®ÀÚ ±ÇÇÑÀ¸·Î ½ÇÇà"À» ´­·¯º¸¼¼¿ä.
) else (
    echo  [OK] °ü¸®ÀÚ ±ÇÇÑÀ¸·Î ½ÇÇà Áß
)

:: 3. winget source update (½ÇÆÐÇØµµ °­Á¦ Á¾·á ±ÝÁö)
echo  [..] ÆÐÅ°Áö ¸ñ·Ï ¾÷µ¥ÀÌÆ® Áß... (Ã³À½ ½ÇÇà ½Ã 1~2ºÐ, ÀÌÈÄ ºü¸§)
winget source update >nul 2>&1
if errorlevel 1 (
    echo  [ÁÖÀÇ] ÆÐÅ°Áö ¸ñ·Ï ¾÷µ¥ÀÌÆ® ½ÇÆÐ - °è¼Ó ÁøÇàÇÕ´Ï´Ù
    >> "%LOG_FILE%" echo ÁÖÀÇ: winget source update ½ÇÆÐ
) else (
    echo  [OK] ÆÐÅ°Áö ¸ñ·Ï ¾÷µ¥ÀÌÆ® ¿Ï·á
    >> "%LOG_FILE%" echo OK: winget source update ¼º°ø
)

:: 4. ÀÎÅÍ³Ý ¿¬°á È®ÀÎ
ping -n 1 -w 3000 8.8.8.8 >nul 2>&1
if errorlevel 1 (
    echo  [ÁÖÀÇ] ÀÎÅÍ³Ý ¿¬°áÀ» È®ÀÎÇÏ¼¼¿ä.
    echo.
    >> "%LOG_FILE%" echo ÁÖÀÇ: ÀÎÅÍ³Ý ¿¬°á ºÒ¾ÈÁ¤
    set CONT_NET=
    set /p CONT_NET="  °è¼Ó ÁøÇàÇÏ½Ã°Ú½À´Ï±î? 1=¿¹ / 2=¾Æ´Ï¿À: "
    if "!CONT_NET!"=="1" set CONT_NET=y
    if /i "!CONT_NET!" NEQ "y" goto MAIN_MENU
) else (
    echo  [OK] ÀÎÅÍ³Ý ¿¬°á È®ÀÎ
    >> "%LOG_FILE%" echo OK: ÀÎÅÍ³Ý ¿¬°á
)

:: µð½ºÅ© ¿©À¯ °ø°£ Ã¼Å© (·¹º§º° ÃÖ¼Ò ±âÁØ)
if not defined DISK_MIN set DISK_MIN=3
powershell -nologo -command "if ((Get-PSDrive C).Free/1GB -lt !DISK_MIN!) { exit 1 }" >nul 2>&1
if errorlevel 1 (
    echo  [°æ°í] Cµå¶óÀÌºê ¿©À¯ °ø°£ !DISK_MIN!GB ¹Ì¸¸ - ¼³Ä¡ Áß ½ÇÆÐÇÒ ¼ö ÀÖ½À´Ï´Ù.
    set CONT_DISK=
    set /p CONT_DISK="  °è¼ÓÇÏ½Ã°Ú½À´Ï±î? 1=¿¹ / 2=¾Æ´Ï¿À: "
    if "!CONT_DISK!"=="1" set CONT_DISK=y
    if /i "!CONT_DISK!" NEQ "y" goto MAIN_MENU
) else (
    echo  [OK] µð½ºÅ© ¿©À¯ °ø°£ È®ÀÎ [!DISK_MIN!GB ÀÌ»ó]
)

:: 5. ±âÁ¸ Node.js °¨Áö (Ãæµ¹ ¾È³»)
where node >nul 2>&1
if not errorlevel 1 (
    for /f %%v in ('node --version 2^>nul') do (
        echo  [¾È³»] ±âÁ¸ Node.js %%v °¨Áö - °Ç³Ê¶Ü Ã³¸®µË´Ï´Ù
        >> "%LOG_FILE%" echo ¾È³»: ±âÁ¸ Node.js %%v °¨Áö
    )
)

:: 6. ±âÁ¸ Python °¨Áö (Ãæµ¹ ¾È³»)
where python >nul 2>&1
if not errorlevel 1 (
    for /f %%v in ('python --version 2^>nul') do (
        echo  [¾È³»] ±âÁ¸ Python %%v °¨Áö - °Ç³Ê¶Ü Ã³¸®µË´Ï´Ù
        >> "%LOG_FILE%" echo ¾È³»: ±âÁ¸ Python %%v °¨Áö
    )
)

echo.
echo  [¿Ï·á] »çÀü Ã¼Å© ¿Ï·á. ¼³Ä¡¸¦ ½ÃÀÛÇÕ´Ï´Ù.
>> "%LOG_FILE%" echo »çÀü Ã¼Å© ¿Ï·á
timeout /t 2 >nul
set START_TIME=%TIME%
goto %PRE_CHECK_RETURN%

:: ============================================================
:: ·¹º§º° ¼³Ä¡ ÁøÀÔÁ¡
:: ============================================================
:DO_LEVEL_1
set LEVEL_NAME=¿ÕÃÊº¸
set DISK_MIN=3
set TOTAL=6
set CURRENT=0
set INSTALL_COUNT=0
set SKIP_COUNT=0
set FAIL_COUNT=0
del "%REPORT_FILE%.tmp" >nul 2>&1
echo.
echo  --------------------------------------------------
echo  [¿ÕÃÊº¸ ¼³Ä¡ ¸ñ·Ï] 6°³ µµ±¸ (¾à 7ºÐ / µð½ºÅ© ~1GB)
echo    Git, Python 3, Node.js LTS, VS Code, Windows Terminal, scoop
echo  --------------------------------------------------
echo.
set CONFIRM_INST=
set /p CONFIRM_INST="  1=¼³Ä¡ ½ÃÀÛ / 2=¸ÞÀÎ ¸Þ´º·Î: "
if "!CONFIRM_INST!"=="1" set CONFIRM_INST=y
if /i "!CONFIRM_INST!" NEQ "y" goto MAIN_MENU
echo.
echo  ÀÌ¹Ì ¼³Ä¡µÈ µµ±¸ Ã³¸® ¹æ¹ý:
echo    [1] °Ç³Ê¶Ü    (ÇöÀç ¹öÀü À¯Áö)
echo    [2] ¾÷±×·¹ÀÌµå (ÃÖ½Å ¹öÀüÀ¸·Î)
echo    [3] Á¦°Å       (»èÁ¦¸¸)
set UPGRADE_CHOICE=
set /p UPGRADE_CHOICE="  ¼±ÅÃ (±âº»°ª=1): "
if "!UPGRADE_CHOICE!"=="" set UPGRADE_CHOICE=1
if "!UPGRADE_CHOICE!"=="2" (set UPGRADE_MODE=upgrade) else (
if "!UPGRADE_CHOICE!"=="3" (set UPGRADE_MODE=remove)  else (
set UPGRADE_MODE=skip))
set PRE_CHECK_RETURN=INSTALL_LEVEL_1
goto PRE_CHECK

:DO_LEVEL_2
set LEVEL_NAME=Áß±Þ
set DISK_MIN=4
set TOTAL=12
set CURRENT=0
set INSTALL_COUNT=0
set SKIP_COUNT=0
set FAIL_COUNT=0
del "%REPORT_FILE%.tmp" >nul 2>&1
echo.
echo  --------------------------------------------------
echo  [Áß±Þ ¼³Ä¡ ¸ñ·Ï] 12°³ µµ±¸ (¾à 15ºÐ / µð½ºÅ© ~2GB)
echo    Git, Python, Node.js, GitHub CLI, PS7, pnpm, Bun, Ollama, VSCode, WinTerminal, scoop
echo  --------------------------------------------------
echo.
set CONFIRM_INST=
set /p CONFIRM_INST="  1=¼³Ä¡ ½ÃÀÛ / 2=¸ÞÀÎ ¸Þ´º·Î: "
if "!CONFIRM_INST!"=="1" set CONFIRM_INST=y
if /i "!CONFIRM_INST!" NEQ "y" goto MAIN_MENU
echo.
echo  ÀÌ¹Ì ¼³Ä¡µÈ µµ±¸ Ã³¸® ¹æ¹ý:
echo    [1] °Ç³Ê¶Ü    (ÇöÀç ¹öÀü À¯Áö)
echo    [2] ¾÷±×·¹ÀÌµå (ÃÖ½Å ¹öÀüÀ¸·Î)
echo    [3] Á¦°Å       (»èÁ¦¸¸)
set UPGRADE_CHOICE=
set /p UPGRADE_CHOICE="  ¼±ÅÃ (±âº»°ª=1): "
if "!UPGRADE_CHOICE!"=="" set UPGRADE_CHOICE=1
if "!UPGRADE_CHOICE!"=="2" (set UPGRADE_MODE=upgrade) else (
if "!UPGRADE_CHOICE!"=="3" (set UPGRADE_MODE=remove)  else (
set UPGRADE_MODE=skip))
set PRE_CHECK_RETURN=INSTALL_LEVEL_2
goto PRE_CHECK

:DO_LEVEL_3
set LEVEL_NAME=°í±Þ
set DISK_MIN=6
set TOTAL=17
set CURRENT=0
set INSTALL_COUNT=0
set SKIP_COUNT=0
set FAIL_COUNT=0
del "%REPORT_FILE%.tmp" >nul 2>&1
echo.
echo  --------------------------------------------------
echo  [°í±Þ ¼³Ä¡ ¸ñ·Ï] 17°³ µµ±¸ (¾à 35ºÐ / µð½ºÅ© ~6GB)
echo    Áß±Þ Æ÷ÇÔ + Java 21 LTS, Flutter+Dart, Go, Rust
echo  --------------------------------------------------
echo.
set CONFIRM_INST=
set /p CONFIRM_INST="  1=¼³Ä¡ ½ÃÀÛ / 2=¸ÞÀÎ ¸Þ´º·Î: "
if "!CONFIRM_INST!"=="1" set CONFIRM_INST=y
if /i "!CONFIRM_INST!" NEQ "y" goto MAIN_MENU
echo.
echo  ÀÌ¹Ì ¼³Ä¡µÈ µµ±¸ Ã³¸® ¹æ¹ý:
echo    [1] °Ç³Ê¶Ü    (ÇöÀç ¹öÀü À¯Áö)
echo    [2] ¾÷±×·¹ÀÌµå (ÃÖ½Å ¹öÀüÀ¸·Î)
echo    [3] Á¦°Å       (»èÁ¦¸¸)
set UPGRADE_CHOICE=
set /p UPGRADE_CHOICE="  ¼±ÅÃ (±âº»°ª=1): "
if "!UPGRADE_CHOICE!"=="" set UPGRADE_CHOICE=1
if "!UPGRADE_CHOICE!"=="2" (set UPGRADE_MODE=upgrade) else (
if "!UPGRADE_CHOICE!"=="3" (set UPGRADE_MODE=remove)  else (
set UPGRADE_MODE=skip))
set PRE_CHECK_RETURN=INSTALL_LEVEL_3
goto PRE_CHECK

:DO_LEVEL_4
set LEVEL_NAME=¿ÃÀÎ¿ø
set DISK_MIN=7
set TOTAL=19
set CURRENT=0
set INSTALL_COUNT=0
set SKIP_COUNT=0
set FAIL_COUNT=0
del "%REPORT_FILE%.tmp" >nul 2>&1
echo.
echo  --------------------------------------------------
echo  [¿ÃÀÎ¿ø ¼³Ä¡ ¸ñ·Ï] 19°³ µµ±¸ (¾à 45ºÐ / µð½ºÅ© ~7GB)
echo    °í±Þ Æ÷ÇÔ + Ruby, PHP
echo  --------------------------------------------------
echo.
set CONFIRM_INST=
set /p CONFIRM_INST="  1=¼³Ä¡ ½ÃÀÛ / 2=¸ÞÀÎ ¸Þ´º·Î: "
if "!CONFIRM_INST!"=="1" set CONFIRM_INST=y
if /i "!CONFIRM_INST!" NEQ "y" goto MAIN_MENU
echo.
echo  ÀÌ¹Ì ¼³Ä¡µÈ µµ±¸ Ã³¸® ¹æ¹ý:
echo    [1] °Ç³Ê¶Ü    (ÇöÀç ¹öÀü À¯Áö)
echo    [2] ¾÷±×·¹ÀÌµå (ÃÖ½Å ¹öÀüÀ¸·Î)
echo    [3] Á¦°Å       (»èÁ¦¸¸)
set UPGRADE_CHOICE=
set /p UPGRADE_CHOICE="  ¼±ÅÃ (±âº»°ª=1): "
if "!UPGRADE_CHOICE!"=="" set UPGRADE_CHOICE=1
if "!UPGRADE_CHOICE!"=="2" (set UPGRADE_MODE=upgrade) else (
if "!UPGRADE_CHOICE!"=="3" (set UPGRADE_MODE=remove)  else (
set UPGRADE_MODE=skip))
set PRE_CHECK_RETURN=INSTALL_LEVEL_4
goto PRE_CHECK

:: ============================================================
:: ¿ÕÃÊº¸ ¼³Ä¡ (5°³) - ÀÇÁ¸¼º ¼ø¼­ ÁØ¼ö
:: ============================================================
:INSTALL_LEVEL_1
cls
echo.
echo  [¿ÕÃÊº¸ ¼³Ä¡] 6°³ µµ±¸¸¦ ¼³Ä¡ÇÕ´Ï´Ù.
echo.
>> "%LOG_FILE%" echo === ¿ÕÃÊº¸ ¼³Ä¡ ½ÃÀÛ: %TIME% ===

:: ÀÇÁ¸¼º 1¼øÀ§: Git
call :INSTALL "Git" "Git.Git"
:: ÀÇÁ¸¼º 2¼øÀ§: Python + Node.js
call :INSTALL "Python 3" "Python.Python.3"
call :INSTALL "Node.js LTS" "OpenJS.NodeJS.LTS"
:: ¼øÀ§¹«°ü
call :INSTALL "VS Code" "Microsoft.VisualStudioCode"
call :INSTALL "Windows Terminal" "Microsoft.WindowsTerminal"

call :INSTALL_SCOOP
call :POST_BEGINNER
call :MAKE_REPORTS
call :PATH_CHECK
call :DONE_MSG
goto MAIN_MENU

:: ============================================================
:: Áß±Þ ¼³Ä¡ (¿ÕÃÊº¸ Æ÷ÇÔ 10°³)
:: ============================================================
:INSTALL_LEVEL_2
cls
echo.
echo  [Áß±Þ ¼³Ä¡] 12°³ µµ±¸¸¦ ¼³Ä¡ÇÕ´Ï´Ù.
echo.
>> "%LOG_FILE%" echo === Áß±Þ ¼³Ä¡ ½ÃÀÛ: %TIME% ===

call :INSTALL "Git" "Git.Git"
call :INSTALL "Git LFS" "GitHub.GitLFS"
call :INSTALL "Python 3" "Python.Python.3"
call :INSTALL "Node.js LTS" "OpenJS.NodeJS.LTS"
call :INSTALL "GitHub CLI" "GitHub.cli"
call :INSTALL "PowerShell 7" "Microsoft.PowerShell"
:: ÀÇÁ¸¼º 3¼øÀ§: Node.js ÀÌÈÄ ÇÊ¼ö
call :INSTALL "pnpm" "pnpm.pnpm"
call :INSTALL "Bun" "Oven-sh.Bun"
call :INSTALL "Ollama" "Ollama.Ollama"
call :INSTALL "VS Code" "Microsoft.VisualStudioCode"
call :INSTALL "Windows Terminal" "Microsoft.WindowsTerminal"

call :INSTALL_SCOOP
call :POST_BEGINNER
call :POST_INTERMEDIATE
call :MAKE_REPORTS
call :PATH_CHECK
call :DONE_MSG
goto MAIN_MENU

:: ============================================================
:: °í±Þ ¼³Ä¡ (Áß±Þ Æ÷ÇÔ 14°³)
:: ============================================================
:INSTALL_LEVEL_3
cls
echo.
echo  [°í±Þ ¼³Ä¡] 17°³ µµ±¸¸¦ ¼³Ä¡ÇÕ´Ï´Ù.
echo.
>> "%LOG_FILE%" echo === °í±Þ ¼³Ä¡ ½ÃÀÛ: %TIME% ===

call :INSTALL "Git" "Git.Git"
call :INSTALL "Git LFS" "GitHub.GitLFS"
call :INSTALL "Python 3" "Python.Python.3"
call :INSTALL "Node.js LTS" "OpenJS.NodeJS.LTS"
call :INSTALL "GitHub CLI" "GitHub.cli"
call :INSTALL "PowerShell 7" "Microsoft.PowerShell"
call :INSTALL "pnpm" "pnpm.pnpm"
call :INSTALL "Bun" "Oven-sh.Bun"
call :INSTALL "Ollama" "Ollama.Ollama"
call :INSTALL "VS Code" "Microsoft.VisualStudioCode"
call :INSTALL "Windows Terminal" "Microsoft.WindowsTerminal"
:: ÀÇÁ¸¼º 4¼øÀ§: Java
call :INSTALL "Java 21 LTS" "EclipseAdoptium.Temurin.21.JDK"
call :INSTALL "Go" "GoLang.Go"
call :INSTALL "Rust" "Rustlang.Rustup"
:: Flutter: winget ÆÐÅ°Áö ¾øÀ½ -> git °ø½Ä stable ¼³Ä¡ (Git ¼±Çà ÇÊ¿ä, Java ºÒÇÊ¿ä)
call :INSTALL_FLUTTER
call :INSTALL "Stripe CLI" "Stripe.StripeCLI"

call :INSTALL_SCOOP
call :POST_BEGINNER
call :POST_INTERMEDIATE
call :POST_ADVANCED
call :RUST_NOTE
call :MAKE_REPORTS
call :PATH_CHECK
call :DONE_MSG
goto MAIN_MENU

:: ============================================================
:: ¿ÃÀÎ¿ø ¼³Ä¡ (°í±Þ Æ÷ÇÔ 16°³)
:: ============================================================
:INSTALL_LEVEL_4
cls
echo.
echo  [¿ÃÀÎ¿ø ¼³Ä¡] 19°³ µµ±¸¸¦ ¼³Ä¡ÇÕ´Ï´Ù.
echo.
>> "%LOG_FILE%" echo === ¿ÃÀÎ¿ø ¼³Ä¡ ½ÃÀÛ: %TIME% ===

call :INSTALL "Git" "Git.Git"
call :INSTALL "Git LFS" "GitHub.GitLFS"
call :INSTALL "Python 3" "Python.Python.3"
call :INSTALL "Node.js LTS" "OpenJS.NodeJS.LTS"
call :INSTALL "GitHub CLI" "GitHub.cli"
call :INSTALL "PowerShell 7" "Microsoft.PowerShell"
call :INSTALL "pnpm" "pnpm.pnpm"
call :INSTALL "Bun" "Oven-sh.Bun"
call :INSTALL "Ollama" "Ollama.Ollama"
call :INSTALL "VS Code" "Microsoft.VisualStudioCode"
call :INSTALL "Windows Terminal" "Microsoft.WindowsTerminal"
call :INSTALL "Java 21 LTS" "EclipseAdoptium.Temurin.21.JDK"
call :INSTALL "Go" "GoLang.Go"
call :INSTALL "Rust" "Rustlang.Rustup"
call :INSTALL_FLUTTER
call :INSTALL "Stripe CLI" "Stripe.StripeCLI"
call :INSTALL "Ruby" "RubyInstallerTeam.RubyWithDevKit.3.3"
call :INSTALL "PHP" "PHP.PHP"

call :INSTALL_SCOOP
call :POST_BEGINNER
call :POST_INTERMEDIATE
call :POST_ADVANCED
call :RUST_NOTE
call :MAKE_REPORTS
call :PATH_CHECK
call :DONE_MSG
goto MAIN_MENU

:: ============================================================
:: µµ±¸ ¼³Ä¡ ¼­ºê·çÆ¾
:: %~1 = µµ±¸ ÀÌ¸§(ÇÑ±Û), %~2 = winget ID
:: ============================================================
:: ============================================================
:: npm Àü¿ª ¼³Ä¡ ¼­ºê·çÆ¾
:: %~1 = µµ±¸ ÀÌ¸§(ÇÑ±Û), %~2 = npm ÆÐÅ°Áö¸í
:: ============================================================
:NPM_INSTALL
echo  [npm] %~1 ¼³Ä¡ Áß...
>> "%LOG_FILE%" echo [npm] %~2 ½ÃÀÛ: %TIME%

npm list -g %~2 >nul 2>&1
if not errorlevel 1 (
    if "!UPGRADE_MODE!"=="upgrade" (
        npm update -g %~2 >nul 2>&1
        echo         [¾÷±×·¹ÀÌµå] %~1 [npm]
        >> "%LOG_FILE%" echo   °á°ú: ¾÷±×·¹ÀÌµå [npm]
        >> "%REPORT_FILE%.tmp" echo   [¾÷±×·¹ÀÌµå] %~1 [npm]
    ) else if "!UPGRADE_MODE!"=="remove" (
        npm uninstall -g %~2 >nul 2>&1
        echo         [Á¦°Å] %~1 [npm]
        >> "%LOG_FILE%" echo   °á°ú: Á¦°Å [npm]
        >> "%REPORT_FILE%.tmp" echo   [Á¦°Å] %~1 [npm]
    ) else (
        echo         [°Ç³Ê¶Ü] %~1 [ÀÌ¹Ì ¼³Ä¡µÊ]
        >> "%LOG_FILE%" echo   °á°ú: °Ç³Ê¶Ü [ÀÌ¹Ì ¼³Ä¡µÊ]
        >> "%REPORT_FILE%.tmp" echo   [°Ç³Ê¶Ü] %~1 [npm]
    )
    goto :eof
)

npm install -g %~2 >nul 2>&1
if not errorlevel 1 (
    echo         [¿Ï·á] %~1
    >> "%LOG_FILE%" echo   °á°ú: ¼º°ø [npm]
    >> "%REPORT_FILE%.tmp" echo   [¼³Ä¡] %~1 [npm]
    goto :eof
)

echo         [Àç½Ãµµ] %~1...
timeout /t 5 /nobreak >nul
npm install -g %~2 >nul 2>&1
if not errorlevel 1 (
    echo         [¿Ï·á] %~1 [Àç½Ãµµ ¼º°ø]
    >> "%REPORT_FILE%.tmp" echo   [¼³Ä¡] %~1 [npm]
    goto :eof
)

echo         [½ÇÆÐ] %~1 npm ¼³Ä¡ ½ÇÆÐ - ÀÎÅÍ³Ý È®ÀÎ ÈÄ ´Ù½Ã ½ÇÇàÇØ º¸¼¼¿ä.
>> "%LOG_FILE%" echo   °á°ú: ½ÇÆÐ (npm)
>> "%REPORT_FILE%.tmp" echo   [½ÇÆÐ] %~1 (npm)
goto :eof

:INSTALL
set /a CURRENT+=1
echo  [!CURRENT!/!TOTAL!] %~1 ¼³Ä¡ Áß...
>> "%LOG_FILE%" echo [!CURRENT!/!TOTAL!] %~2 ½ÃÀÛ: %TIME%

winget install --id %~2 --source winget --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
set INST_ERR=!errorlevel!

if !INST_ERR! EQU 0 (
echo         [92m[¿Ï·á][0m %~1
    >> "%LOG_FILE%" echo   °á°ú: ¼º°ø [errorlevel=0]
    set /a INSTALL_COUNT+=1
    >> "%REPORT_FILE%.tmp" echo   [¼º°ø] %~1
    goto :eof
)

:: errorlevel 0ÀÌ ¾Æ´Ñ °æ¿ì ? winget list·Î ÀÌ¹Ì ¼³Ä¡µÊ ¿©ºÎ È®ÀÎ
winget list --id %~2 --source winget >nul 2>&1
if not errorlevel 1 (
    if "!UPGRADE_MODE!"=="upgrade" (
        winget upgrade --id %~2 --source winget --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
        echo         [¾÷±×·¹ÀÌµå] %~1
        >> "%LOG_FILE%" echo   °á°ú: ¾÷±×·¹ÀÌµå [errorlevel=!INST_ERR!]
        set /a INSTALL_COUNT+=1
        >> "%REPORT_FILE%.tmp" echo   [¾÷±×·¹ÀÌµå] %~1
    ) else if "!UPGRADE_MODE!"=="remove" (
        winget uninstall --id %~2 --source winget --silent >nul 2>&1
        echo         [Á¦°Å] %~1
        >> "%LOG_FILE%" echo   °á°ú: Á¦°Å
        set /a SKIP_COUNT+=1
        >> "%REPORT_FILE%.tmp" echo   [Á¦°Å] %~1
    ) else (
        echo         [°Ç³Ê¶Ü] %~1 [ÀÌ¹Ì ¼³Ä¡µÊ]
        >> "%LOG_FILE%" echo   °á°ú: °Ç³Ê¶Ü [ÀÌ¹Ì ¼³Ä¡µÊ, errorlevel=!INST_ERR!]
        set /a SKIP_COUNT+=1
        >> "%REPORT_FILE%.tmp" echo   [°Ç³Ê¶Ü] %~1
    )
    goto :eof
)

:: ½ÇÁ¦ ½ÇÆÐ ? 5ÃÊ ÈÄ 1È¸ ÀÚµ¿ Àç½Ãµµ
echo         [Àç½Ãµµ] %~1 ½ÇÆÐ ? 5ÃÊ ÈÄ Àç½Ãµµ...
>> "%LOG_FILE%" echo   1Â÷ ½ÇÆÐ (errorlevel=!INST_ERR!), Àç½Ãµµ: %TIME%
timeout /t 5 /nobreak >nul

winget install --id %~2 --source winget --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
set RETRY_ERR=!errorlevel!

if !RETRY_ERR! EQU 0 (
echo         [92m[¿Ï·á][0m %~1 [Àç½Ãµµ ¼º°ø]
    >> "%LOG_FILE%" echo   Àç½Ãµµ ¼º°ø [errorlevel=0]: %TIME%
    set /a INSTALL_COUNT+=1
    >> "%REPORT_FILE%.tmp" echo   [¼º°ø] %~1 [Àç½Ãµµ]
    goto :eof
)

winget list --id %~2 --source winget >nul 2>&1
if not errorlevel 1 (
    if "!UPGRADE_MODE!"=="upgrade" (
        winget upgrade --id %~2 --source winget --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
        echo         [¾÷±×·¹ÀÌµå] %~1
        >> "%LOG_FILE%" echo   °á°ú: ¾÷±×·¹ÀÌµå
        set /a INSTALL_COUNT+=1
        >> "%REPORT_FILE%.tmp" echo   [¾÷±×·¹ÀÌµå] %~1
    ) else if "!UPGRADE_MODE!"=="remove" (
        winget uninstall --id %~2 --source winget --silent >nul 2>&1
        echo         [Á¦°Å] %~1
        >> "%LOG_FILE%" echo   °á°ú: Á¦°Å
        set /a SKIP_COUNT+=1
        >> "%REPORT_FILE%.tmp" echo   [Á¦°Å] %~1
    ) else (
        echo         [°Ç³Ê¶Ü] %~1 [ÀÌ¹Ì ¼³Ä¡µÊ]
        >> "%LOG_FILE%" echo   °á°ú: °Ç³Ê¶Ü
        set /a SKIP_COUNT+=1
        >> "%REPORT_FILE%.tmp" echo   [°Ç³Ê¶Ü] %~1
    )
) else (
echo         [91m[½ÇÆÐ][0m %~1 ¼³Ä¡ ½ÇÆÐ - °ÆÁ¤¸¶¼¼¿ä! ¸Þ´º [8] Á÷Á¢ ´Ù¿î·Îµå¿¡¼­ ¹ÞÀ» ¼ö ÀÖ¾î¿ä.
    >> "%LOG_FILE%" echo   Àç½Ãµµ ½ÇÆÐ [errorlevel=!RETRY_ERR!]: %TIME%
    set /a FAIL_COUNT+=1
    >> "%REPORT_FILE%.tmp" echo   [½ÇÆÐ] %~1
)
goto :eof

:: ============================================================
:: Post-install: ¿ÕÃÊº¸ (Git autocrlf, pip ¾÷±×·¹ÀÌµå, npm fund)
:: ============================================================
:POST_BEGINNER
echo.
echo  ---------------------------------------------------
echo  [¼³Ä¡ ÈÄ ÀÚµ¿ ¼³Á¤]
echo.

:: Git autocrlf ÀÚµ¿ ¼³Á¤ (Windows ÁÙ¹Ù²Þ Ç¥ÁØ, Ã¹ Ä¿¹Ô ¿À·ù ¿¹¹æ)
where git >nul 2>&1
if not errorlevel 1 (
    git config --global core.autocrlf true >nul 2>&1
    >> "%LOG_FILE%" echo POST: git config --global core.autocrlf true ¿Ï·á
    echo  [ÀÚµ¿] Git ÁÙ¹Ù²Þ ¼³Á¤ ¿Ï·á [autocrlf=true]
    echo.
    echo  - Git »ç¿ëÀÚ Á¤º¸´Â Á÷Á¢ ¼³Á¤ÀÌ ÇÊ¿äÇÕ´Ï´Ù:
    echo.
    echo      git config --global user.name  "È«±æµ¿"
    echo      git config --global user.email "your@email.com"
    echo.
)

:: pip ¾÷±×·¹ÀÌµå ÀÚµ¿ ½ÇÇà (pip °æ°í Á¦°Å)
where python >nul 2>&1
if not errorlevel 1 (
    python -m pip install --upgrade pip >nul 2>&1
    >> "%LOG_FILE%" echo POST: pip upgrade ¿Ï·á
    echo  [ÀÚµ¿] pip ¾÷±×·¹ÀÌµå ¿Ï·á
)

:: npm ±¤°í ¸Þ½ÃÁö Á¦°Å (ÃÊº¸ÀÚ È¥¶õ ¹æÁö)
where npm >nul 2>&1
if not errorlevel 1 (
    npm config set fund false >nul 2>&1
    >> "%LOG_FILE%" echo POST: npm config set fund false ¿Ï·á
    echo  [ÀÚµ¿] npm ±¤°í ¸Þ½ÃÁö Á¦°Å ¿Ï·á
    echo  [AI ÇÊ¼öµµ±¸] Claude Code CLI ¼³Ä¡ Áß...
    npm install -g @anthropic-ai/claude-code >nul 2>&1
    if not errorlevel 1 (
        >> "%LOG_FILE%" echo POST: Claude Code CLI ¼³Ä¡ ¼º°ø
        echo  [¿Ï·á] Claude Code CLI ¼³Ä¡ ¿Ï·á - »õ ÅÍ¹Ì³Î¿¡¼­ claude --version
    ) else (
        >> "%LOG_FILE%" echo POST: Claude Code CLI ¼³Ä¡ ½ÇÆÐ
        echo  [½ÇÆÐ] Claude Code CLI ¼³Ä¡ ½ÇÆÐ - ÀÎÅÍ³Ý È®ÀÎ ÈÄ npm install -g @anthropic-ai/claude-code ·Î Àç½Ãµµ
    )
)
echo.
goto :eof

:: ============================================================
:: Post-install: Áß±Þ (Ollama ¸ðµ¨ ¾È³» ? ÀÚµ¿ ´Ù¿î·Îµå ±ÝÁö)
:: ============================================================
:POST_INTERMEDIATE
where ollama >nul 2>&1
if not errorlevel 1 (
    echo  - Ollama ·ÎÄÃ AI ¸ðµ¨ ¾È³» [2GB ÀÌ»ó ? Á÷Á¢ ½ÇÇà]:
    echo.
    echo      ollama pull llama3.2   [¾à 2GB]
    echo      ollama pull gemma3     [¾à 3GB]
    echo.
)

echo  [ÀÚµ¿] ¹èÆ÷/DB CLI µµ±¸ npm ¼³Ä¡ Áß...
set INST_VERCEL=
set /p INST_VERCEL="  Vercel CLI ¼³Ä¡ÇÒ±î¿ä? 1=¿¹ / 2=¾Æ´Ï¿À: "
if "!INST_VERCEL!"=="1" set INST_VERCEL=y
if /i "!INST_VERCEL!"=="y" call :NPM_INSTALL "Vercel CLI" "vercel"
set INST_SUPABASE=
set /p INST_SUPABASE="  Supabase CLI ¼³Ä¡ÇÒ±î¿ä? 1=¿¹ / 2=¾Æ´Ï¿À: "
if "!INST_SUPABASE!"=="1" set INST_SUPABASE=y
if /i "!INST_SUPABASE!"=="y" call :NPM_INSTALL "Supabase CLI" "supabase"
set INST_STRIPE=
set /p INST_STRIPE="  Stripe SDK ¼³Ä¡ÇÒ±î¿ä? 1=¿¹ / 2=¾Æ´Ï¿À: "
if "!INST_STRIPE!"=="1" set INST_STRIPE=y
if /i "!INST_STRIPE!"=="y" call :NPM_INSTALL "Stripe SDK" "stripe"
set INST_RESEND=
set /p INST_RESEND="  Resend SDK ¼³Ä¡ÇÒ±î¿ä? 1=¿¹ / 2=¾Æ´Ï¿À: "
if "!INST_RESEND!"=="1" set INST_RESEND=y
if /i "!INST_RESEND!"=="y" call :NPM_INSTALL "Resend SDK" "resend"
goto :eof

:: ============================================================
:: Post-install: °í±Þ (Rust toolchain, VS Code È®Àå URL ¾È³»)
:: ============================================================
:POST_ADVANCED
where rustup >nul 2>&1
if not errorlevel 1 (
    rustup update stable >nul 2>&1
    >> "%LOG_FILE%" echo POST: rustup update stable ¿Ï·á
    echo  [ÀÚµ¿] Rust toolchain ¾÷µ¥ÀÌÆ® ¿Ï·á
    echo.
)

echo  - VS Code È®Àå ÇÁ·Î±×·¥ (Á÷Á¢ ¼³Ä¡):
echo.
echo      Python:   https://marketplace.visualstudio.com/items?itemName=ms-python.python
echo      Prettier: https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode
echo.

echo  [ÀÚµ¿] °í±Þ ¹èÆ÷ CLI ¼³Ä¡ Áß...
call :NPM_INSTALL "Railway CLI" "@railway/cli"
goto :eof

:: ============================================================
:: ¸®Æ÷Æ® »ý¼º 2Á¾ (¿ä¾à + »ó¼¼)
:: ============================================================
:MAKE_REPORTS
set END_TIME=%TIME%
:: Elapsed time (octal-safe)
for /f "tokens=1-3 delims=:." %%a in ("%START_TIME: =0%") do set /a _SS=10#%%a*3600+10#%%b*60+10#%%c
for /f "tokens=1-3 delims=:." %%a in ("%END_TIME: =0%") do set /a _ES=10#%%a*3600+10#%%b*60+10#%%c
set /a _EL=_ES-_SS
if !_EL! LSS 0 set /a _EL+=86400
set /a _EM=_EL/60
set /a _EL_S=_EL %% 60
echo  ¼Ò¿ä ½Ã°£: !_EM!ºÐ !_EL_S!ÃÊ
>> "%LOG_FILE%" echo ¼Ò¿ä ½Ã°£: !_EM!ºÐ !_EL_S!ÃÊ

if not exist "%REPORT_FILE%.tmp" >> "%REPORT_FILE%.tmp" echo   (¼³Ä¡ Ç×¸ñ ¾øÀ½)

:: °­»ç¿ë ¿ä¾à ¸®Æ÷Æ®
(
    echo ====================================================
    echo  ¹ÙÀÌºêÄÚµù È¯°æ Å°Æ® - ¼³Ä¡ ¸®Æ÷Æ®
    echo ====================================================
    echo  PC ÀÌ¸§:    %COMPUTERNAME%
    echo  ¼³Ä¡ ·¹º§:  %LEVEL_NAME%
    echo  ¼³Ä¡ ³¯Â¥:  %DATE%
    echo  ½ÃÀÛ ½Ã°¢:  %START_TIME%
    echo  ¿Ï·á ½Ã°¢:  %END_TIME%
    echo  ¼º°ø: %INSTALL_COUNT%°³  °Ç³Ê¶Ü: %SKIP_COUNT%°³  ½ÇÆÐ: %FAIL_COUNT%°³
    echo ====================================================
    type "%REPORT_FILE%.tmp"
    echo ====================================================
    echo  µµ¿òÀÌ ÇÊ¿äÇÏ¸é ÀÌ ÆÄÀÏÀ» °­»ç ¶Ç´Â µµ¿ÍÁÖ´Â ºÐ²² Àü´ÞÇÏ¼¼¿ä.
    echo ====================================================
) > "%REPORT_FILE%"

del "%REPORT_FILE%.tmp" >nul 2>&1

>> "%LOG_FILE%" echo.
>> "%LOG_FILE%" echo === ¼³Ä¡ ¿Ï·á: %END_TIME% ===
>> "%LOG_FILE%" echo ¼º°ø: %INSTALL_COUNT% / °Ç³Ê¶Ü: %SKIP_COUNT% / ½ÇÆÐ: %FAIL_COUNT%

echo.
echo  [¸®Æ÷Æ® ÀúÀå ¿Ï·á] µµ¿òÀÌ ÇÊ¿äÇÏ¸é ¾Æ·¡ ÆÄÀÏÀ» °­»ç ¶Ç´Â µµ¿ÍÁÖ´Â ºÐ²² Àü´ÞÇØ ÁÖ¼¼¿ä:
echo    %REPORT_FILE%  (¼³Ä¡ °á°ú ¿ä¾à)
echo    %LOG_FILE%     (¹®Á¦ È®ÀÎ¿ë »ó¼¼)
goto :eof

:: ============================================================
:: PATH °ËÁõ Ãâ·Â (¼³Ä¡ ¿Ï·á ÈÄ ´«À¸·Î È®ÀÎ)
:: ============================================================
:PATH_CHECK
echo.
echo  ---------------------------------------------------
echo  [PATH °ËÁõ] ÇöÀç ÅÍ¹Ì³Î¿¡¼­ ÀÎ½ÄµÇ´Â µµ±¸
echo  ---------------------------------------------------
for %%c in (git python node npm pnpm bun go rustc rustup flutter dart java gh pwsh ruby php adb scrcpy) do (
    where %%c >nul 2>&1
    if not errorlevel 1 echo    [O] %%c
)
echo.
goto :eof

:: ============================================================
:: ¼³Ä¡ ¿Ï·á ¸Þ½ÃÁö
:: ============================================================
:DONE_MSG
echo  ---------------------------------------------------
if !FAIL_COUNT! GTR 0 (
    echo  [ÁÖÀÇ] ÀÏºÎ µµ±¸ ¼³Ä¡ ½ÇÆÐ: !FAIL_COUNT!°³
    echo         %LOG_FILE% ¸¦ °­»ç ¶Ç´Â µµ¿ÍÁÖ´Â ºÐ²² Àü´ÞÇÏ¼¼¿ä.
    echo.
)
if !FAIL_COUNT! GTR 0 (
    echo  ¼³Ä¡ °úÁ¤ÀÌ ³¡³µ½À´Ï´Ù. ½ÇÆÐÇÑ µµ±¸´Â À§ ¾È³»¸¦ È®ÀÎÇÏ¼¼¿ä.
) else (
    echo  ¼³Ä¡°¡ ¿Ï·áµÇ¾ú½À´Ï´Ù.
)
echo.
echo  [´ÙÀ½ ´Ü°è °¡ÀÌµå]
echo   1. »õ ÅÍ¹Ì³Î ¿­±â (½ÃÀÛ¸Þ´º -> Windows Terminal ¶Ç´Â PowerShell)
echo   2. git --version / python --version / node --version ÀÔ·Â È®ÀÎ
echo   3. git config --global user.name "È«±æµ¿" Çü½ÄÀ¸·Î ÀÌ¸§ ¼³Á¤
echo   4. git config --global user.email "my@email.com" Çü½ÄÀ¸·Î ÀÌ¸ÞÀÏ ¼³Á¤
echo   5. °¢ µµ±¸ ¼³Ä¡ È®ÀÎ: [9] ¼³Ä¡ È®ÀÎ ¸Þ´º ÀÌ¿ë
echo.
echo  --- ÁÖ¿ä CLI ¹öÀü È®ÀÎ ---
echo   vercel --version
echo   supabase --version
echo   npx prisma --version
echo   claude --version
echo.
echo  [¹ÙÀÌºêÄÚµù Ã¹ °ÉÀ½]
echo   1. Cursor ¶Ç´Â VS Code ¸¦ ¿±´Ï´Ù.
echo   2. Claude ¿¡ ·Î±×ÀÎÇÕ´Ï´Ù (Claude Desktop, ¶Ç´Â ÅÍ¹Ì³Î¿¡¼­ claude ¸í·É).
echo   3. »õ Æú´õ¸¦ ¿­°í, ¸¸µé°í ½ÍÀº °ÍÀ» ÇÑ±¹¾î·Î ±×´ë·Î Àû¾îº¸¼¼¿ä.
echo      ¿¹: °£´ÜÇÑ ¸Þ¸ð ¾Û ¸¸µé¾îÁà
echo.
echo.
echo  »õ ÅÍ¹Ì³ÎÀ» ¿­¾î¼­ ½ÃÀÛÇÏ¼¼¿ä.
echo  (ÇöÀç Ã¢Àº PATH º¯°æ Àü »óÅÂÀÔ´Ï´Ù)
echo.
pause
goto :eof

:: ============================================================
:: ¼±ÅÃ ¼³Ä¡
:: ============================================================
:: ¼±ÅÃ ¼³Ä¡
:: ============================================================
:DO_EASY
cls
echo.
echo  [°¡Àå ½¬¿î ÃßÃµ ¼³Ä¡]
echo  Ã³À½ ½ÃÀÛ¿¡ ÇÊ¿äÇÑ ÇÙ½É µµ±¸¸¦ ÇÑ ¹ø¿¡ ¼³Ä¡ÇÕ´Ï´Ù.
echo    - ±âº» 5Á¾: Git, Python, Node.js, VS Code, Windows Terminal
echo    - AI: Claude Code[ÀÚµ¿ ¼³Ä¡]. Cursor / Claude Desktop Àº ´Ù¿î·Îµå ÆäÀÌÁö¸¦ ¿±´Ï´Ù(Á÷Á¢ ¼³Ä¡).
echo.
set CONFIRM_EASY=
set /p CONFIRM_EASY="  1=¼³Ä¡ ½ÃÀÛ / 2=¸ÞÀÎ ¸Þ´º·Î: "
if "!CONFIRM_EASY!"=="1" set CONFIRM_EASY=y
if /i "!CONFIRM_EASY!" NEQ "y" goto MAIN_MENU
set UPGRADE_MODE=skip
set LEVEL_NAME=ÃßÃµ¼³Ä¡
set DISK_MIN=3
set TOTAL=5
set CURRENT=0
set INSTALL_COUNT=0
set SKIP_COUNT=0
set FAIL_COUNT=0
del "%REPORT_FILE%.tmp" >nul 2>&1
set PRE_CHECK_RETURN=INSTALL_EASY
goto PRE_CHECK

:INSTALL_EASY
cls
echo.
echo  [ÃßÃµ ¼³Ä¡] ÇÙ½É 5Á¾À» ¼³Ä¡ÇÕ´Ï´Ù.
echo.
>> "%LOG_FILE%" echo === ÃßÃµ ¼³Ä¡ ½ÃÀÛ: %TIME% ===
call :INSTALL "Git" "Git.Git"
call :INSTALL "Python 3" "Python.Python.3"
call :INSTALL "Node.js LTS" "OpenJS.NodeJS.LTS"
call :INSTALL "VS Code" "Microsoft.VisualStudioCode"
call :INSTALL "Windows Terminal" "Microsoft.WindowsTerminal"
call :POST_BEGINNER
call :MAKE_REPORTS
call :PATH_CHECK
echo.
echo  [¾È³»] AI µµ±¸´Â ÇÁ·Î±×·¥ÀÌ¶ó Á÷Á¢ ¼³Ä¡°¡ ÇÊ¿äÇÕ´Ï´Ù. ´Ù¿î·Îµå ÆäÀÌÁö¸¦ ¿±´Ï´Ù...
echo    - Cursor(AI ÄÚµå ¿¡µðÅÍ) / Claude Desktop(AI Ã¤ÆÃ)
start "" "https://cursor.com/ko/download"
start "" "https://claude.com/ko-kr/download"
call :DONE_MSG
goto MAIN_MENU

:DO_SELECT
cls
echo.
echo  ===================================================
echo   [ ¼±ÅÃ ¼³Ä¡ ]  ¹øÈ£¸¦ ½°Ç¥·Î ÀÔ·Â  (¿¹: 1,3,6)
echo  ===================================================
echo.
echo   [ ±âº» µµ±¸ ]   (Ã³À½ÀÌ¸é [1]~[5] ±ÇÀå)
echo     [1]  Git             [2]  Python 3        [3]  Node.js LTS
echo     [4]  VS Code         [5]  Windows Terminal
echo     [6]  GitHub CLI      [7]  PowerShell 7    [8]  pnpm
echo     [9]  Ollama          [10] Bun
echo.
echo   [ ¾ð¾î / ·±Å¸ÀÓ ]   (Æ¯Á¤ ¹öÀüÀº ¸ÞÀÎ ¸Þ´º [V] ¿¡¼­)
echo     [11] Java 21 LTS     [12] Flutter         [13] Go
echo     [14] Rust
echo.
echo   [ ¿ÃÀÎ¿ø / Ãß°¡ µµ±¸ (winget) ]
echo     [15] Ruby            [16] PHP             [17] Git LFS
echo     [18] Stripe CLI      [27] uv
echo.
echo   [ ¸ð¹ÙÀÏ ¾Û °³¹ß ]   (Flutter ´Â À§ [12], ÇÑ ¹ø¿¡ ¼³Ä¡´Â ¸ÞÀÎ ¸Þ´º [M])
echo     [28] Android Studio  [29] adb [Android ÇÃ·§Æû µµ±¸]  [30] scrcpy
echo.
echo   [ ¹èÆ÷ / DB / ÇÁ·ÎÁ§Æ® (npm) ]
echo     [19] Vercel CLI      [20] Supabase CLI    [21] Stripe SDK
echo     [22] Resend SDK      [23] Railway CLI     [24] Clerk
echo     [25] Prisma          [26] Uploadthing
echo        ([24] Supabase Auth ¾²¸é ºÒÇÊ¿ä / [25] DB ORM / [26] ÆÄÀÏ¾÷·Îµå)
echo.
echo  ---------------------------------------------------
echo    [0] ¸ÞÀÎ ¸Þ´º·Î       [Enter] ±ÇÀå ±âº»ÆÑ([1]~[5]) ¼³Ä¡
echo  ---------------------------------------------------
echo.
set SEL=
set /p SEL="  ¹øÈ£ ÀÔ·Â: "
if "!SEL!"=="0" goto MAIN_MENU
if "!SEL!"=="" set SEL=1,2,3,4,5
:: ÀÔ·Â °ËÁõ: 1~30 ¼ýÀÚ¿Í ½°Ç¥/°ø¹é¸¸ Çã¿ë [Æ¯¼ö¹®ÀÚ°¡ for ¹®À» ±ú¶ß·Á ¸ØÃß°Å³ª, ¾ø´Â ¹øÈ£·Î °¡Â¥ ¿Ï·á°¡ ¶ß´Â °Í ¹æÁö]
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $ok = ($env:SEL -match '^[0-9, ]+$'); foreach($n in ($env:SEL -split '[, ]+')){ if($n -ne ''){ if([int]$n -lt 1 -or [int]$n -gt 30){ $ok = $false } } }; if($ok){ exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
if errorlevel 1 (
    echo.
    echo  [¾È³»] ¹øÈ£´Â 1ºÎÅÍ 30 »çÀÌÀÇ ¼ýÀÚ¸¸, ½°Ç¥·Î ±¸ºÐÇØ¼­ ÀÔ·ÂÇÏ¼¼¿ä. ¿¹: 1,3,6
    pause
    goto DO_SELECT
)

echo.
echo  ¼±ÅÃ: !SEL!
echo  ---------------------------------------------------
echo  ¼³Ä¡ÇÒ µµ±¸:
for %%n in (%SEL:,= %) do (
    if "%%n"=="1" echo    - Git
    if "%%n"=="2" echo    - Python 3
    if "%%n"=="3" echo    - Node.js LTS
    if "%%n"=="4" echo    - VS Code
    if "%%n"=="5" echo    - Windows Terminal
    if "%%n"=="6" echo    - GitHub CLI
    if "%%n"=="7" echo    - PowerShell 7
    if "%%n"=="8" echo    - pnpm
    if "%%n"=="9" echo    - Ollama
    if "%%n"=="10" echo    - Bun
    if "%%n"=="11" echo    - Java 21 LTS
    if "%%n"=="12" echo    - Flutter+Dart
    if "%%n"=="13" echo    - Go
    if "%%n"=="14" echo    - Rust
    if "%%n"=="15" echo    - Ruby
    if "%%n"=="16" echo    - PHP
    if "%%n"=="17" echo    - Git LFS
    if "%%n"=="18" echo    - Stripe CLI
    if "%%n"=="19" echo    - Vercel CLI [npm]
    if "%%n"=="20" echo    - Supabase CLI [npm]
    if "%%n"=="21" echo    - Stripe SDK [npm]
    if "%%n"=="22" echo    - Resend SDK [npm]
    if "%%n"=="23" echo    - Railway CLI [npm]
    if "%%n"=="24" echo    - Clerk [npm]
    if "%%n"=="25" echo    - Prisma [npm]
    if "%%n"=="26" echo    - Uploadthing [npm]
    if "%%n"=="27" echo    - uv
    if "%%n"=="28" echo    - Android Studio
    if "%%n"=="29" echo    - adb [Android ÇÃ·§Æû µµ±¸]
    if "%%n"=="30" echo    - scrcpy [Æù È­¸é ¹Ì·¯¸µ]
)
echo  ---------------------------------------------------
set CONFIRM_SEL=
set /p CONFIRM_SEL="  1=¼³Ä¡ ½ÃÀÛ / 2=´Ù½Ã ¼±ÅÃ: "
if "!CONFIRM_SEL!"=="1" set CONFIRM_SEL=y
if /i "!CONFIRM_SEL!" NEQ "y" goto DO_SELECT
echo.
echo  ÀÌ¹Ì ¼³Ä¡µÈ µµ±¸ Ã³¸® ¹æ¹ý:
echo    [1] °Ç³Ê¶Ü    (ÇöÀç ¹öÀü À¯Áö)
echo    [2] ¾÷±×·¹ÀÌµå (ÃÖ½Å ¹öÀüÀ¸·Î)
echo    [3] Á¦°Å       (»èÁ¦¸¸)
set UPGRADE_CHOICE=
set /p UPGRADE_CHOICE="  ¼±ÅÃ (±âº»°ª=1): "
if "!UPGRADE_CHOICE!"=="" set UPGRADE_CHOICE=1
if "!UPGRADE_CHOICE!"=="2" (set UPGRADE_MODE=upgrade) else (
if "!UPGRADE_CHOICE!"=="3" (set UPGRADE_MODE=remove)  else (
set UPGRADE_MODE=skip))

set LEVEL_NAME=¼±ÅÃ¼³Ä¡
set DISK_MIN=3
set TOTAL=0
set CURRENT=0
set INSTALL_COUNT=0
set SKIP_COUNT=0
set FAIL_COUNT=0
del "%REPORT_FILE%.tmp" >nul 2>&1

set START_TIME=%TIME%
for %%n in (%SEL:,= %) do set /a TOTAL+=1

>> "%LOG_FILE%" echo.
>> "%LOG_FILE%" echo === ¼±ÅÃ ¼³Ä¡ ¸ñ·Ï: !SEL! ===

:: pnpm(8), Bun(10), npm µµ±¸(19-26) -> Node.js ¼±Çà ¼³Ä¡
set NEED_NODE=
for %%n in (8 10 19 20 21 22 23 24 25 26) do (
    for %%s in (!SEL!) do if "%%s"=="%%n" set NEED_NODE=1
)
if defined NEED_NODE (
    where node >nul 2>&1
    if errorlevel 1 (
        echo  [¾È³»] Node.js°¡ ÇÊ¿äÇÕ´Ï´Ù. ¸ÕÀú ¼³Ä¡ÇÕ´Ï´Ù.
        set /a TOTAL+=1
        call :INSTALL "Node.js LTS" "OpenJS.NodeJS.LTS"
    )
)
set NEED_NODE=

:: Flutter(12) -> Git ¼±Çà ¼³Ä¡ (Flutter ´Â git À¸·Î ¹ÞÀ½. Java ´Â ÇÊ¿ä ¾øÀ½)
echo !SEL! | findstr /C:"12" >nul 2>&1
if not errorlevel 1 (
    call :FIND_GIT
    if not defined FL_GIT (
        echo  [¾È³»] Flutter´Â GitÀÌ ÇÊ¿äÇÕ´Ï´Ù. ¸ÕÀú ¼³Ä¡ÇÕ´Ï´Ù.
        set /a TOTAL+=1
        call :INSTALL "Git" "Git.Git"
    )
)

set MOB_SHOW=
set RUST_SHOW=
for %%n in (%SEL:,= %) do (
    if "%%n"=="1"  call :INSTALL "Git" "Git.Git"
    if "%%n"=="2"  call :INSTALL "Python 3" "Python.Python.3"
    if "%%n"=="3"  call :INSTALL "Node.js LTS" "OpenJS.NodeJS.LTS"
    if "%%n"=="4"  call :INSTALL "VS Code" "Microsoft.VisualStudioCode"
    if "%%n"=="5"  call :INSTALL "Windows Terminal" "Microsoft.WindowsTerminal"
    if "%%n"=="6"  call :INSTALL "GitHub CLI" "GitHub.cli"
    if "%%n"=="7"  call :INSTALL "PowerShell 7" "Microsoft.PowerShell"
    if "%%n"=="8"  call :INSTALL "pnpm" "pnpm.pnpm"
    if "%%n"=="9"  call :INSTALL "Ollama" "Ollama.Ollama"
    if "%%n"=="10" call :INSTALL "Bun" "Oven-sh.Bun"
    if "%%n"=="11" call :INSTALL "Java 21 LTS" "EclipseAdoptium.Temurin.21.JDK"
    if "%%n"=="12" call :INSTALL_FLUTTER
    if "%%n"=="13" call :INSTALL "Go" "GoLang.Go"
    if "%%n"=="14" call :INSTALL "Rust" "Rustlang.Rustup"
    if "%%n"=="15" call :INSTALL "Ruby" "RubyInstallerTeam.RubyWithDevKit.3.3"
    if "%%n"=="16" call :INSTALL "PHP" "PHP.PHP"
    if "%%n"=="17" call :INSTALL "Git LFS" "GitHub.GitLFS"
    if "%%n"=="18" call :INSTALL "Stripe CLI" "Stripe.StripeCLI"
    if "%%n"=="19" call :NPM_INSTALL "Vercel CLI" "vercel"
    if "%%n"=="20" call :NPM_INSTALL "Supabase CLI" "supabase"
    if "%%n"=="21" call :NPM_INSTALL "Stripe SDK" "stripe"
    if "%%n"=="22" call :NPM_INSTALL "Resend SDK" "resend"
    if "%%n"=="23" call :NPM_INSTALL "Railway CLI" "@railway/cli"
    if "%%n"=="24" call :NPM_INSTALL "Clerk" "@clerk/clerk-sdk-node"
    if "%%n"=="25" call :NPM_INSTALL "Prisma" "prisma"
    if "%%n"=="26" call :NPM_INSTALL "Uploadthing" "uploadthing"
    if "%%n"=="27" call :INSTALL "uv" "astral-sh.uv"
    if "%%n"=="28" call :INSTALL "Android Studio" "Google.AndroidStudio"
    if "%%n"=="29" call :INSTALL "adb [Android ÇÃ·§Æû µµ±¸]" "Google.PlatformTools"
    if "%%n"=="30" call :INSTALL "scrcpy [Æù È­¸é ¹Ì·¯¸µ]" "Genymobile.scrcpy"
    if "%%n"=="12" set MOB_SHOW=1
    if "%%n"=="28" set MOB_SHOW=1
    if "%%n"=="29" set MOB_SHOW=1
    if "%%n"=="14" set RUST_SHOW=1
)

if defined MOB_SHOW call :POST_MOBILE
set MOB_SHOW=
if defined RUST_SHOW call :RUST_NOTE
set RUST_SHOW=
call :MAKE_REPORTS
call :PATH_CHECK
call :DONE_MSG
goto MAIN_MENU

:: ============================================================
:: ¹öÀü ¼±ÅÃ ¼³Ä¡ (¾ÈÁ¤/LTS ¹öÀü¸¸)
:: ============================================================
:DO_VERSION
cls
echo.
echo  [¹öÀü ¼±ÅÃ ¼³Ä¡] Æ¯Á¤ ¾ÈÁ¤(LTS) ¹öÀüÀ» °ñ¶ó ¼³Ä¡ÇÕ´Ï´Ù.
echo  Àß ¸ð¸£°ÚÀ¸¸é [0]À¸·Î µ¹¾Æ°¡ [1] ¿ÕÃÊº¸ ¶Ç´Â [A] ÃßÃµ ¼³Ä¡¸¦ ¾²¼¼¿ä.
echo  ---------------------------------------------------
echo    [1] Python      [2] Java(JDK)      [3] Ruby
echo    [0] ¸ÞÀÎ ¸Þ´º·Î
echo.
set VER_LANG=
set /p VER_LANG="  ¾ð¾î ¹øÈ£: "
if "!VER_LANG!"=="0" goto MAIN_MENU
if "!VER_LANG!"=="1" goto VER_PYTHON
if "!VER_LANG!"=="2" goto VER_JAVA
if "!VER_LANG!"=="3" goto VER_RUBY
goto DO_VERSION

:VER_PYTHON
echo.
echo  [Python ¹öÀü] ¾ÈÁ¤ ¹öÀü¸¸ - Àß ¸ð¸£¸é ±×³É Enter
echo    [1] 3.13    [2] 3.12    [3] 3.11
set PV=
set /p PV="  ¼±ÅÃ (±âº»=ÃÖ½Å ±ÇÀå): "
set VER_NAME=Python
set VER_ID=Python.Python.3
if "!PV!"=="1" set VER_ID=Python.Python.3.13
if "!PV!"=="2" set VER_ID=Python.Python.3.12
if "!PV!"=="3" set VER_ID=Python.Python.3.11
goto VER_INSTALL

:VER_JAVA
echo.
echo  [Java(JDK) ¹öÀü] ÀüºÎ LTS - Àß ¸ð¸£¸é ±×³É Enter
echo    [1] 21(±ÇÀå)    [2] 17    [3] 11    [4] 8
set JV=
set /p JV="  ¼±ÅÃ (±âº»=21 LTS): "
set VER_NAME=Java-JDK
set VER_ID=EclipseAdoptium.Temurin.21.JDK
if "!JV!"=="2" set VER_ID=EclipseAdoptium.Temurin.17.JDK
if "!JV!"=="3" set VER_ID=EclipseAdoptium.Temurin.11.JDK
if "!JV!"=="4" set VER_ID=EclipseAdoptium.Temurin.8.JDK
goto VER_INSTALL

:VER_RUBY
echo.
echo  [Ruby ¹öÀü] ¾ÈÁ¤ ¹öÀü - Àß ¸ð¸£¸é ±×³É Enter
echo    [1] 3.3(±ÇÀå)    [2] 3.2
set RV=
set /p RV="  ¼±ÅÃ (±âº»=3.3): "
set VER_NAME=Ruby
set VER_ID=RubyInstallerTeam.RubyWithDevKit.3.3
if "!RV!"=="2" set VER_ID=RubyInstallerTeam.RubyWithDevKit.3.2
goto VER_INSTALL

:VER_INSTALL
set LEVEL_NAME=¹öÀü¼±ÅÃ
set DISK_MIN=3
set TOTAL=1
set CURRENT=0
set INSTALL_COUNT=0
set SKIP_COUNT=0
set FAIL_COUNT=0
set UPGRADE_MODE=skip
del "%REPORT_FILE%.tmp" >nul 2>&1
set PRE_CHECK_RETURN=VER_INSTALL2
goto PRE_CHECK

:VER_INSTALL2
cls
echo.
echo  [¹öÀü ¼±ÅÃ ¼³Ä¡] !VER_NAME! : !VER_ID! ¸¦ ¼³Ä¡ÇÕ´Ï´Ù.
echo.
>> "%LOG_FILE%" echo === ¹öÀü¼±ÅÃ ¼³Ä¡: !VER_ID! : %TIME% ===
call :INSTALL "!VER_NAME!" "!VER_ID!"
call :MAKE_REPORTS
call :PATH_CHECK
call :DONE_MSG
goto MAIN_MENU

:DO_UPDATE
cls
echo.
echo  [¾ÈÀü ¾÷µ¥ÀÌÆ®] º£Å¸°¡ ¾Æ´Ñ '¾ÈÁ¤(LTS)' ¹öÀüÀ¸·Î¸¸ Á¡°ËÇÏ°í ¾÷µ¥ÀÌÆ®ÇÕ´Ï´Ù.
echo.
>> "%LOG_FILE%" echo === ÀüÃ¼ ¾÷µ¥ÀÌÆ® ½ÃÀÛ: %TIME% ===

echo  (Node¿Í Java´Â LTS ¶óÀÎ ¾È¿¡¼­¸¸ ¿Ã¶ó°¡¸ç, ÀÌ Å°Æ®°¡ ¼³Ä¡ÇÑ µµ±¸¸¸ ´ë»óÀÔ´Ï´Ù.)
echo.
echo  [È®ÀÎ] Âü°í·Î, Áö±Ý ¾÷µ¥ÀÌÆ® °¡´ÉÇÑ ÀüÃ¼ ¸ñ·ÏÀÔ´Ï´Ù...
winget upgrade --source winget
echo.
set DO_UPD=
set /p DO_UPD="  Å°Æ® µµ±¸¸¦ ¾ÈÀüÇÏ°Ô ¾÷µ¥ÀÌÆ®ÇÒ±î¿ä? 1=¿¹ / 2=¾Æ´Ï¿À: "
if "!DO_UPD!"=="1" set DO_UPD=y
if /i "!DO_UPD!" NEQ "y" goto MAIN_MENU
echo.
for %%p in (Git.Git GitHub.GitLFS Python.Python.3 OpenJS.NodeJS.LTS GitHub.cli Microsoft.PowerShell pnpm.pnpm Oven-sh.Bun Ollama.Ollama Microsoft.VisualStudioCode Microsoft.WindowsTerminal EclipseAdoptium.Temurin.21.JDK GoLang.Go Rustlang.Rustup Stripe.StripeCLI RubyInstallerTeam.RubyWithDevKit.3.3 PHP.PHP EclipseAdoptium.Temurin.17.JDK EclipseAdoptium.Temurin.11.JDK EclipseAdoptium.Temurin.8.JDK Python.Python.3.13 Python.Python.3.12 Python.Python.3.11 RubyInstallerTeam.RubyWithDevKit.3.2 Google.AndroidStudio Google.PlatformTools Genymobile.scrcpy astral-sh.uv Obsidian.Obsidian MarkText.MarkText Zettlr.Zettlr) do (
    winget upgrade --id %%p --source winget --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    if not errorlevel 1 echo  [¾÷±×·¹ÀÌµå] %%p
)
echo  [¾È³»] Flutter ´Â winget ÀÌ ¾Æ´Ï¶ó ÅÍ¹Ì³Î¿¡¼­ flutter upgrade ·Î ¾÷µ¥ÀÌÆ®ÇÏ¼¼¿ä.
echo  [¾È³»] Docker Desktop Àº ÇÁ·Î±×·¥ ¾È¿¡¼­ ½º½º·Î ¾÷µ¥ÀÌÆ®ÇÕ´Ï´Ù.
echo  [¾È³»] PostgreSQL Àº DB µ¥ÀÌÅÍ º¸È£¸¦ À§ÇØ Å°Æ®°¡ ÀÚµ¿À¸·Î ¿Ã¸®Áö ¾Ê½À´Ï´Ù. ¹öÀüÀ» ¿Ã¸± ¶§´Â µ¥ÀÌÅÍ¸¦ ¹é¾÷ÇÑ µÚ Á÷Á¢ ÇÏ¼¼¿ä.
echo  [¾È³»] C++ ºôµå µµ±¸´Â ½ÃÀÛ ¸Þ´ºÀÇ Visual Studio Installer ¿¡¼­ ¾÷µ¥ÀÌÆ®ÇÏ¼¼¿ä.
>> "%LOG_FILE%" echo ÀüÃ¼ ¾÷µ¥ÀÌÆ® ¿Ï·á: %TIME%
echo.
echo  [¿Ï·á] ¾÷µ¥ÀÌÆ® ¿Ï·á.
pause
goto MAIN_MENU

:: ============================================================
:: Á¦°Å
:: ============================================================
:DO_REMOVE
cls
echo.
echo  [Á¦°Å ¸Þ´º]
echo    [1] °³º° µµ±¸ Á¦°Å
echo    [2] ÀüÃ¼ Á¦°Å
echo    [0] ¸ÞÀÎ ¸Þ´º
echo.
echo  * 0 = ¸ÞÀÎ ¸Þ´º·Î µ¹¾Æ°¡±â
set REM_CHOICE=
set /p REM_CHOICE="  ¹øÈ£: "
if "!REM_CHOICE!"=="0" goto MAIN_MENU
if "!REM_CHOICE!"=="1" goto REMOVE_ONE
if "!REM_CHOICE!"=="2" goto REMOVE_ALL
goto DO_REMOVE

:REMOVE_ONE
cls
echo.
echo  [°³º° Á¦°Å] Á¦°ÅÇÒ µµ±¸ ¹øÈ£¸¦ ÀÔ·ÂÇÏ¼¼¿ä
echo.
echo  [1]Git  [2]Python  [3]Node.js  [4]VSCode  [5]WinTerminal
echo  [6]GitHub CLI  [7]PS7  [8]pnpm  [9]Ollama  [10]Bun
echo  [11]Java21  [12]Flutter  [13]Go  [14]Rust  [15]Ruby  [16]PHP
echo  [17]Git LFS  [18]Stripe CLI
echo  [19]uv
echo  [20]Android Studio  [21]adb  [22]scrcpy
echo  [23]Obsidian  [24]MarkText  [25]Zettlr
echo  [26]Docker Desktop  [27]PostgreSQL  [28]C++ ºôµå µµ±¸
echo  [0] µÚ·Î
echo.
set REM_SEL=
set /p REM_SEL="  ¹øÈ£: "
if "!REM_SEL!"=="0"  goto DO_REMOVE
set REM_OK=
for /L %%i in (1,1,28) do if "!REM_SEL!"=="%%i" set REM_OK=1
if not defined REM_OK (
    echo.
    echo  [¾È³»] ¸ñ·Ï¿¡ ÀÖ´Â ¹øÈ£ 1~28 Áß¿¡¼­ ÀÔ·ÂÇÏ¼¼¿ä. ¾Æ¹«°Íµµ Á¦°ÅÇÏÁö ¾Ê¾Ò½À´Ï´Ù.
    pause
    goto REMOVE_ONE
)

set REM_CANCEL=
if "!REM_SEL!"=="1"  winget uninstall --id Git.Git --source winget --silent
if "!REM_SEL!"=="2"  winget uninstall --id Python.Python.3 --source winget --silent
if "!REM_SEL!"=="2"  winget uninstall --id Python.Python.3.13 --source winget --silent >nul 2>&1
if "!REM_SEL!"=="2"  winget uninstall --id Python.Python.3.12 --source winget --silent >nul 2>&1
if "!REM_SEL!"=="2"  winget uninstall --id Python.Python.3.11 --source winget --silent >nul 2>&1
if "!REM_SEL!"=="3"  winget uninstall --id OpenJS.NodeJS.LTS --source winget --silent
if "!REM_SEL!"=="4"  winget uninstall --id Microsoft.VisualStudioCode --source winget --silent
if "!REM_SEL!"=="5"  winget uninstall --id Microsoft.WindowsTerminal --source winget --silent
if "!REM_SEL!"=="6"  winget uninstall --id GitHub.cli --source winget --silent
if "!REM_SEL!"=="7"  winget uninstall --id Microsoft.PowerShell --source winget --silent
if "!REM_SEL!"=="8"  winget uninstall --id pnpm.pnpm --source winget --silent
if "!REM_SEL!"=="9"  winget uninstall --id Ollama.Ollama --source winget --silent
if "!REM_SEL!"=="10" winget uninstall --id Oven-sh.Bun --source winget --silent
if "!REM_SEL!"=="11" winget uninstall --id EclipseAdoptium.Temurin.21.JDK --source winget --silent
if "!REM_SEL!"=="11" winget uninstall --id EclipseAdoptium.Temurin.17.JDK --source winget --silent >nul 2>&1
if "!REM_SEL!"=="11" winget uninstall --id EclipseAdoptium.Temurin.11.JDK --source winget --silent >nul 2>&1
if "!REM_SEL!"=="11" winget uninstall --id EclipseAdoptium.Temurin.8.JDK --source winget --silent >nul 2>&1
if "!REM_SEL!"=="12" call :REMOVE_FLUTTER
if "!REM_SEL!"=="13" winget uninstall --id GoLang.Go --source winget --silent
if "!REM_SEL!"=="14" winget uninstall --id Rustlang.Rustup --source winget --silent
if "!REM_SEL!"=="15" winget uninstall --id RubyInstallerTeam.RubyWithDevKit.3.3 --source winget --silent
if "!REM_SEL!"=="15" winget uninstall --id RubyInstallerTeam.RubyWithDevKit.3.2 --source winget --silent >nul 2>&1
if "!REM_SEL!"=="16" winget uninstall --id PHP.PHP --source winget --silent
if "!REM_SEL!"=="17" winget uninstall --id GitHub.GitLFS --source winget --silent
if "!REM_SEL!"=="18" winget uninstall --id Stripe.StripeCLI --source winget --silent
if "!REM_SEL!"=="19" winget uninstall --id astral-sh.uv --source winget --silent
if "!REM_SEL!"=="20" winget uninstall --id Google.AndroidStudio --source winget --silent
if "!REM_SEL!"=="20" echo  [¾È³»] Android SDK Æú´õ [%LOCALAPPDATA%\Android\Sdk] ´Â Áö¿ìÁö ¾Ê¾Ò½À´Ï´Ù. ÇÊ¿äÇÏ¸é Á÷Á¢ »èÁ¦ÇÏ¼¼¿ä.
if "!REM_SEL!"=="21" winget uninstall --id Google.PlatformTools --source winget --silent
if "!REM_SEL!"=="22" winget uninstall --id Genymobile.scrcpy --source winget --silent
if "!REM_SEL!"=="23" winget uninstall --id Obsidian.Obsidian --source winget --silent
if "!REM_SEL!"=="24" winget uninstall --id MarkText.MarkText --source winget --silent
if "!REM_SEL!"=="25" winget uninstall --id Zettlr.Zettlr --source winget --silent
if "!REM_SEL!"=="26" winget uninstall --id Docker.DockerDesktop --source winget --silent
if "!REM_SEL!"=="26" echo  [¾È³»] Docker ·Î ¹ÞÀº ÀÌ¹ÌÁö¿Í ÄÁÅ×ÀÌ³Ê µ¥ÀÌÅÍ´Â ³²¾Æ ÀÖÀ» ¼ö ÀÖ½À´Ï´Ù.
if "!REM_SEL!"=="27" call :REMOVE_PG
if "!REM_SEL!"=="28" call :REMOVE_BUILDTOOLS
echo.
if defined REM_CANCEL (echo  [¾È³»] Ãë¼ÒÇß½À´Ï´Ù. ¾Æ¹«°Íµµ Á¦°ÅÇÏÁö ¾Ê¾Ò½À´Ï´Ù.) else echo  [¿Ï·á] Á¦°Å ¿Ï·á.
pause
goto MAIN_MENU

:REMOVE_ALL
echo.
echo  [°æ°í] ÀÌ Å°Æ®·Î ¼³Ä¡ÇÑ ¸ðµç µµ±¸¸¦ Á¦°ÅÇÕ´Ï´Ù.
set REM_ALL_CONFIRM=
set /p REM_ALL_CONFIRM="  1=ÀüÃ¼ Á¦°Å ÁøÇà / 2=Ãë¼Ò: "
if "!REM_ALL_CONFIRM!"=="1" set REM_ALL_CONFIRM=y
if /i "!REM_ALL_CONFIRM!" NEQ "y" goto DO_REMOVE

echo  Á¦°Å Áß... (½Ã°£ÀÌ °É¸± ¼ö ÀÖ½À´Ï´Ù)
for %%i in (
    Obsidian.Obsidian
    MarkText.MarkText
    Zettlr.Zettlr
    Docker.DockerDesktop
    Genymobile.scrcpy
    Google.PlatformTools
    Google.AndroidStudio
    astral-sh.uv
    GitHub.GitLFS
    Stripe.StripeCLI
    PHP.PHP
    RubyInstallerTeam.RubyWithDevKit.3.3
    RubyInstallerTeam.RubyWithDevKit.3.2
    Rustlang.Rustup
    GoLang.Go
    EclipseAdoptium.Temurin.21.JDK
    EclipseAdoptium.Temurin.17.JDK
    EclipseAdoptium.Temurin.11.JDK
    EclipseAdoptium.Temurin.8.JDK
    Oven-sh.Bun
    pnpm.pnpm
    Ollama.Ollama
    Microsoft.PowerShell
    GitHub.cli
    Microsoft.WindowsTerminal
    Microsoft.VisualStudioCode
    OpenJS.NodeJS.LTS
    Python.Python.3
    Python.Python.3.13
    Python.Python.3.12
    Python.Python.3.11
    Git.Git
) do (
    winget uninstall --id %%i --source winget --silent >nul 2>&1
    echo    Á¦°Å: %%i
)
call :REMOVE_FLUTTER
echo  [¾È³»] Android SDK Æú´õ [%LOCALAPPDATA%\Android\Sdk] ´Â Áö¿ìÁö ¾Ê¾Ò½À´Ï´Ù. ÇÊ¿äÇÏ¸é Á÷Á¢ »èÁ¦ÇÏ¼¼¿ä.
echo  [¾È³»] PostgreSQL °ú C++ ºôµå µµ±¸´Â µ¥ÀÌÅÍ¿Í ´Ù¸¥ ÇÁ·Î±×·¥¿¡ ¿µÇâÀÌ ÀÖ¾î ÀüÃ¼ Á¦°Å¿¡ ³ÖÁö ¾Ê¾Ò½À´Ï´Ù.
echo         ÇÊ¿äÇÏ¸é °³º° Á¦°ÅÀÇ 27¹ø 28¹øÀ» ¾²¼¼¿ä.
echo.
echo  [npm] npm ÆÐÅ°Áö Á¦°Å Áß...
for %%p in (vercel supabase stripe resend @railway/cli @clerk/clerk-sdk-node prisma uploadthing) do (
    npm uninstall -g %%p >nul 2>&1
    echo    [npm] Á¦°Å: %%p
)
echo.
echo  [¿Ï·á] ÀüÃ¼ Á¦°Å ¿Ï·á.
pause
goto MAIN_MENU

:: ============================================================
:: ¼öµ¿ ¼³Ä¡ ¾È³» (Cursor ÃÖ¿ì¼±)
:: ============================================================
:DO_MANUAL
cls
echo.
echo  [Á÷Á¢ ´Ù¿î·Îµå ¸µÅ©]
echo  - AI ÄÚµù ¿¡µðÅÍ [17] Cursor ¸¦ °¡Àå ¸ÕÀú ¼³Ä¡ÇÏ´Â °ÍÀ» ÃßÃµÇÕ´Ï´Ù.
echo  winget ¼³Ä¡°¡ ¾È µÉ ¶§ °ø½Ä »çÀÌÆ®¿¡¼­ Á÷Á¢ ¹ÞÀ¸¼¼¿ä.
echo  ---------------------------------------------------
echo  ¹øÈ£¸¦ ÀÔ·ÂÇÏ°Å³ª, URL À§¿¡¼­ Ctrl+Å¬¸¯ ÇÏ¸é ºê¶ó¿ìÀú¿¡¼­ ¿­¸³´Ï´Ù.
echo.
echo   --- ¿ÕÃÊº¸ µµ±¸ ---
echo    [1]  Git               https://git-scm.com/download/win
echo    [2]  Python 3          https://www.python.org/downloads/
echo    [3]  Node.js LTS       https://nodejs.org/en/download
echo    [4]  VS Code           https://code.visualstudio.com/download
echo    [5]  Windows Terminal  https://aka.ms/terminal
echo.
echo   --- Áß±Þ µµ±¸ ---
echo    [6]  GitHub CLI        https://cli.github.com/
echo    [7]  PowerShell 7      https://github.com/PowerShell/PowerShell/releases/latest
echo    [8]  pnpm              https://pnpm.io/installation
echo    [9]  Ollama            https://ollama.com/download/windows
echo    [10] Bun               https://bun.sh/
echo.
echo   --- °í±Þ µµ±¸ ---
echo    [11] Java 21 LTS       https://adoptium.net/
echo    [12] Flutter           https://docs.flutter.dev/get-started/install/windows
echo    [13] Go                https://go.dev/dl/
echo    [14] Rust              https://rustup.rs/
echo.
echo   --- ¿ÃÀÎ¿ø µµ±¸ ---
echo    [15] Ruby              https://rubyinstaller.org/downloads/
echo    [16] PHP               https://windows.php.net/download/
echo.
echo   --- AI µµ±¸ (º°µµ ¼³Ä¡ ÇÊ¿ä) ---
echo    [17] Cursor            https://cursor.com/ko/download
echo    [18] Claude Desktop    https://claude.com/ko-kr/download
echo    [19] GitHub Desktop    https://desktop.github.com/download/
echo    [22] LM Studio         https://lmstudio.ai/
echo    [23] Windsurf          https://windsurf.com/
echo    [24] Warp              https://www.warp.dev/
echo.
echo   --- ¸ð¹ÙÀÏ ¾Û °³¹ß ---
echo    [25] Android Studio    https://developer.android.com/studio
echo    [26] Platform-Tools    https://developer.android.com/tools/releases/platform-tools
echo    [27] scrcpy            https://github.com/Genymobile/scrcpy
echo.
echo   --- ºÐ¾ßº° °³¹ß È¯°æ [D] ---
echo    [28] Obsidian          https://obsidian.md/download
echo    [29] MarkText          https://github.com/marktext/marktext/releases
echo    [30] Zettlr            https://www.zettlr.com/download
echo    [31] Typora [À¯·á]     https://typora.io/
echo    [32] Docker Desktop    https://www.docker.com/products/docker-desktop/
echo    [33] PostgreSQL        https://www.postgresql.org/download/windows/
echo    [34] C++ ºôµå µµ±¸     https://visualstudio.microsoft.com/visual-cpp-build-tools/
echo.echo   --- °³¹ß È®Àå CLI ---
echo    [20] GitHub LFS        https://git-lfs.com/
echo    [21] Stripe CLI        https://docs.stripe.com/stripe-cli
echo.
echo  ---------------------------------------------------
echo    [0] ¸ÞÀÎ ¸Þ´º·Î
echo.
set MAN_CHOICE=
set /p MAN_CHOICE="  ¹øÈ£ ÀÔ·Â: "
if "!MAN_CHOICE!"=="0" goto MAIN_MENU

set _OPENED=0
if "!MAN_CHOICE!"=="1"  start "" "https://git-scm.com/download/win"                              & set _OPENED=1
if "!MAN_CHOICE!"=="2"  start "" "https://www.python.org/downloads/"                              & set _OPENED=1
if "!MAN_CHOICE!"=="3"  start "" "https://nodejs.org/en/download"                                 & set _OPENED=1
if "!MAN_CHOICE!"=="4"  start "" "https://code.visualstudio.com/download"                         & set _OPENED=1
if "!MAN_CHOICE!"=="5"  start "" "https://aka.ms/terminal"                                        & set _OPENED=1
if "!MAN_CHOICE!"=="6"  start "" "https://cli.github.com/"                                        & set _OPENED=1
if "!MAN_CHOICE!"=="7"  start "" "https://github.com/PowerShell/PowerShell/releases/latest"       & set _OPENED=1
if "!MAN_CHOICE!"=="8"  start "" "https://pnpm.io/installation"                                   & set _OPENED=1
if "!MAN_CHOICE!"=="9"  start "" "https://ollama.com/download/windows"                            & set _OPENED=1
if "!MAN_CHOICE!"=="10" start "" "https://bun.sh/"                                                & set _OPENED=1
if "!MAN_CHOICE!"=="11" start "" "https://adoptium.net/"                                          & set _OPENED=1
if "!MAN_CHOICE!"=="12" start "" "https://docs.flutter.dev/get-started/install/windows"   & set _OPENED=1
if "!MAN_CHOICE!"=="13" start "" "https://go.dev/dl/"                                             & set _OPENED=1
if "!MAN_CHOICE!"=="14" start "" "https://rustup.rs/"                                             & set _OPENED=1
if "!MAN_CHOICE!"=="15" start "" "https://rubyinstaller.org/downloads/"                           & set _OPENED=1
if "!MAN_CHOICE!"=="16" start "" "https://windows.php.net/download/"                              & set _OPENED=1
if "!MAN_CHOICE!"=="17" start "" "https://cursor.com/ko/download"                                 & set _OPENED=1
if "!MAN_CHOICE!"=="18" start "" "https://claude.com/ko-kr/download"                              & set _OPENED=1
if "!MAN_CHOICE!"=="19" start "" "https://desktop.github.com/download/"                           & set _OPENED=1
if "!MAN_CHOICE!"=="22" start "" "https://lmstudio.ai/"   & set _OPENED=1
if "!MAN_CHOICE!"=="23" start "" "https://windsurf.com/"  & set _OPENED=1
if "!MAN_CHOICE!"=="24" start "" "https://www.warp.dev/"  & set _OPENED=1
if "!MAN_CHOICE!"=="25" start "" "https://developer.android.com/studio"  & set _OPENED=1
if "!MAN_CHOICE!"=="26" start "" "https://developer.android.com/tools/releases/platform-tools"  & set _OPENED=1
if "!MAN_CHOICE!"=="27" start "" "https://github.com/Genymobile/scrcpy"  & set _OPENED=1
if "!MAN_CHOICE!"=="28" start "" "https://obsidian.md/download"  & set _OPENED=1
if "!MAN_CHOICE!"=="29" start "" "https://github.com/marktext/marktext/releases"  & set _OPENED=1
if "!MAN_CHOICE!"=="30" start "" "https://www.zettlr.com/download"  & set _OPENED=1
if "!MAN_CHOICE!"=="31" start "" "https://typora.io/"  & set _OPENED=1
if "!MAN_CHOICE!"=="32" start "" "https://www.docker.com/products/docker-desktop/"  & set _OPENED=1
if "!MAN_CHOICE!"=="33" start "" "https://www.postgresql.org/download/windows/"  & set _OPENED=1
if "!MAN_CHOICE!"=="34" start "" "https://visualstudio.microsoft.com/visual-cpp-build-tools/"  & set _OPENED=1
if "!MAN_CHOICE!"=="20" start "" "https://git-lfs.com/"                                          & set _OPENED=1
if "!MAN_CHOICE!"=="21" start "" "https://docs.stripe.com/stripe-cli"                            & set _OPENED=1

if "!_OPENED!"=="1" echo. & echo  ºê¶ó¿ìÀú°¡ ¿­·È½À´Ï´Ù. ´Ù¿î·Îµå ÈÄ ¼³Ä¡ÇÏ¼¼¿ä. & echo. & pause
goto DO_MANUAL
:: ============================================================
:: ¼³Ä¡ »óÅÂ È®ÀÎ (O/X)
:: ============================================================
:DO_CHECK
cls
echo.
echo  [¼³Ä¡ »óÅÂ È®ÀÎ]
echo  ---------------------------------------------------
echo.

echo  [ ±âº» °³¹ß µµ±¸ ]
call :CHECK_ONE "Git" git
call :CHECK_ONE "Git LFS" git-lfs
call :CHECK_ONE "Python 3" python
call :CHECK_ONE "Node.js" node
call :CHECK_ONE "npm" npm
call :CHECK_ONE "VS Code" code
call :CHECK_ONE "Windows Terminal" wt
call :CHECK_ONE "GitHub CLI" gh
call :CHECK_ONE "PowerShell 7" pwsh
call :CHECK_ONE "pnpm" pnpm
call :CHECK_ONE "Ollama" ollama
call :CHECK_ONE "Bun" bun
call :CHECK_ONE "scoop" scoop
echo.
echo  [ ¾ð¾î / ·±Å¸ÀÓ ]
call :CHECK_ONE "Java" java
where flutter >nul 2>&1
if errorlevel 1 (
    echo    [X] Flutter
) else (
    set _FV=
    for /f "tokens=2" %%v in ('flutter --version 2^>nul ^| findstr /B "Flutter"') do if not defined _FV set _FV=%%v
    if defined _FV (echo    [O] Flutter  !_FV!) else echo    [O] Flutter
)
call :CHECK_ONE "Dart" dart
call :CHECK_ONE "Go" go
call :CHECK_ONE "Rust" rustc
call :CHECK_ONE "Cargo" cargo
call :CHECK_ONE "Ruby" ruby
call :CHECK_ONE "PHP" php
echo.
echo  [ ¸ð¹ÙÀÏ ¾Û °³¹ß ]
call :CHECK_STUDIO
call :CHECK_ONE "adb" adb
call :CHECK_ONE "scrcpy" scrcpy
echo.
echo  [ ºÐ¾ßº° °³¹ß È¯°æ / ¹®¼­ ]
call :CHECK_BUILD
call :CHECK_ONE "Docker" docker
call :CHECK_WG "PostgreSQL 17" PostgreSQL.PostgreSQL.17
call :CHECK_WG "Obsidian" Obsidian.Obsidian
call :CHECK_WG "MarkText" MarkText.MarkText
call :CHECK_WG "Zettlr" Zettlr.Zettlr
echo.
echo  [ ¹èÆ÷ / DB CLI ]
call :CHECK_ONE "Stripe CLI" stripe
call :CHECK_ONE "Vercel CLI" vercel
call :CHECK_ONE "Supabase CLI" supabase
call :CHECK_ONE "Railway CLI" railway
call :CHECK_ONE "Prisma" prisma
call :CHECK_ONE "uv" uv
echo.
echo  [ AI ¿¡µðÅÍ ]
call :CHECK_ONE "Cursor" cursor
call :CHECK_ONE "Claude Code CLI" claude
where flutter >nul 2>&1
if not errorlevel 1 (
    echo.
    set FD_RUN=
    set /p FD_RUN="  flutter doctor ·Î ¸ð¹ÙÀÏ °³¹ß ÁØºñ »óÅÂµµ Á¡°ËÇÒ±î¿ä? 1~2ºÐ °É¸± ¼ö ÀÖ½À´Ï´Ù. 1=¿¹ / 2=¾Æ´Ï¿À: "
    if "!FD_RUN!"=="1" set FD_RUN=y
    if /i "!FD_RUN!"=="y" call :FLUTTER_DOCTOR_SUMMARY
)

echo.
echo  ---------------------------------------------------
echo  »õ ÅÍ¹Ì³Î¿¡¼­ È®ÀÎ ½Ã ´õ Á¤È®ÇÑ °á°ú°¡ ³ª¿É´Ï´Ù.
pause
goto MAIN_MENU

:: %~1 = Ç¥½Ã ÀÌ¸§, %~2 = ½ÇÇàÆÄÀÏ¸í
:CHECK_ONE
where %~2 >nul 2>&1
if errorlevel 1 (
    echo    [X] %~1
    goto :eof
)
set CHK_VER=
for /f "tokens=*" %%v in ('%~2 --version 2^>nul') do if not defined CHK_VER set CHK_VER=%%v
if defined CHK_VER (
    echo    [O] %~1  !CHK_VER!
) else (
    echo    [O] %~1
)
goto :eof

:: ============================================================
:: Á¾·á
:: ============================================================
:: ============================================================
:: scoop ¼³Ä¡ (winget ¹ÌÁö¿ø -> °ø½Ä ¼³Ä¡ ½ºÅ©¸³Æ®, »ç¿ëÀÚ µ¿ÀÇ ÇÊ¿ä)
:: ============================================================
:: ============================================================
:: Flutter ¼³Ä¡ ÇïÆÛ (winget ¿¡ Flutter ÆÐÅ°Áö°¡ ¾øÀ½ -> °ø½Ä ÀúÀå¼Ò git clone, stable)
:: À§Ä¡: %USERPROFILE%\develop\flutter  [Flutter °ø½Ä ¹®¼­ ±ÇÀå: °ø¹é/°ü¸®ÀÚ °æ·Î È¸ÇÇ]
:: ÀÌ¹Ì ÀÖÀ¸¸é °Ç³Ê¶Ü. Æú´õ°¡ ÀÌ¹Ì ÀÖÀ¸¸é Àý´ë µ¤¾î¾²°Å³ª Áö¿ìÁö ¾ÊÀ½. »ç¿ëÀÚ PATH ¿¡¸¸ Ãß°¡.
:: ============================================================
:INSTALL_FLUTTER
set /a CURRENT+=1
echo  [!CURRENT!/!TOTAL!] Flutter+Dart ¼³Ä¡ Áß...
>> "%LOG_FILE%" echo [!CURRENT!/!TOTAL!] Flutter ½ÃÀÛ: %TIME%
if not defined USERPROFILE goto FLUTTER_FAIL_NOHOME
set "FL_DIR=%USERPROFILE%\develop\flutter"
set "FL_BIN=%USERPROFILE%\develop\flutter\bin"
where flutter >nul 2>&1
if not errorlevel 1 goto FLUTTER_SKIP
if exist "!FL_BIN!\flutter.bat" goto FLUTTER_SKIP_ADDPATH
if exist "!FL_DIR!" goto FLUTTER_FAIL_EXISTS
call :FIND_GIT
if not defined FL_GIT goto FLUTTER_FAIL_NOGIT
if not exist "%USERPROFILE%\develop" mkdir "%USERPROFILE%\develop" >nul 2>&1
set GIT_TERMINAL_PROMPT=0
echo         °ø½Ä ÀúÀå¼Ò¿¡¼­ ³»·Á¹Þ´Â Áß... ¸î ºÐ °É¸± ¼ö ÀÖ½À´Ï´Ù.
"!FL_GIT!" -c core.longpaths=true clone https://github.com/flutter/flutter.git -b stable "!FL_DIR!" >nul 2>&1
set INST_ERR=!errorlevel!
if !INST_ERR! EQU 0 goto FLUTTER_CLONED
echo         [Àç½Ãµµ] Flutter+Dart ½ÇÆÐ - 5ÃÊ ÈÄ Àç½Ãµµ...
>> "%LOG_FILE%" echo   1Â÷ ½ÇÆÐ [errorlevel=!INST_ERR!], Àç½Ãµµ: %TIME%
:: À§¿¡¼­ Æú´õ°¡ ¾øÀ½À» È®ÀÎÇßÀ¸¹Ç·Î Áö±Ý ÀÖ´Â Æú´õ´Â ¹æ±Ý ½ÇÆÐÇÑ clone ÀÌ ¸¸µç °Í
if exist "!FL_DIR!" rmdir /s /q "!FL_DIR!" >nul 2>&1
timeout /t 5 /nobreak >nul
"!FL_GIT!" -c core.longpaths=true clone https://github.com/flutter/flutter.git -b stable "!FL_DIR!" >nul 2>&1
set INST_ERR=!errorlevel!
if !INST_ERR! NEQ 0 goto FLUTTER_FAIL_CLONE
:FLUTTER_CLONED
:: ±ä °æ·Î ÆÄÀÏÀÌ ÀÖ¾î ÀÌÈÄ flutter upgrade µµ ½ÇÆÐÇÏÁö ¾Êµµ·Ï, ÀÌ ÀúÀå¼Ò¿¡¸¸ ¼³Á¤ [Àü¿ª ¼³Á¤ ¾Æ´Ô]
"!FL_GIT!" -C "!FL_DIR!" config core.longpaths true >nul 2>&1
call :FLUTTER_PATH_ADD
echo         Dart SDK ÁØºñ Áß... Ã³À½ ÇÑ ¹ø¸¸ ¸î ºÐ °É¸± ¼ö ÀÖ½À´Ï´Ù.
call "!FL_BIN!\flutter.bat" --version >nul 2>&1
if errorlevel 1 goto FLUTTER_FAIL_FIRSTRUN
echo         [92m[¿Ï·á][0m Flutter+Dart
>> "%LOG_FILE%" echo   °á°ú: ¼º°ø [git clone stable, Ã¹ ½ÇÇà È®ÀÎ]
set /a INSTALL_COUNT+=1
>> "%REPORT_FILE%.tmp" echo   [¼º°ø] Flutter+Dart
goto :eof

:FLUTTER_SKIP_ADDPATH
call :FLUTTER_PATH_ADD
:FLUTTER_SKIP
echo         [°Ç³Ê¶Ü] Flutter+Dart [ÀÌ¹Ì ¼³Ä¡µÊ]
>> "%LOG_FILE%" echo   °á°ú: °Ç³Ê¶Ü [Flutter ÀÌ¹Ì ÀÖÀ½]
set /a SKIP_COUNT+=1
>> "%REPORT_FILE%.tmp" echo   [°Ç³Ê¶Ü] Flutter+Dart
goto :eof

:FLUTTER_FAIL_NOHOME
echo         [91m[½ÇÆÐ][0m Flutter+Dart - »ç¿ëÀÚ Æú´õ À§Ä¡¸¦ ¾Ë ¼ö ¾ø¾î ¼³Ä¡ÇÏÁö ¾Ê½À´Ï´Ù.
>> "%LOG_FILE%" echo   °á°ú: ½ÇÆÐ [USERPROFILE ¾øÀ½]
goto FLUTTER_FAIL_COUNT

:FLUTTER_FAIL_EXISTS
echo         [91m[½ÇÆÐ][0m Flutter+Dart - ¼³Ä¡ À§Ä¡¿¡ Æú´õ°¡ ÀÌ¹Ì ÀÖ¾î µ¤¾î¾²Áö ¾Ê½À´Ï´Ù.
echo                 !FL_DIR!
echo                 Á÷Á¢ È®ÀÎÇÏ½Ã°Å³ª Æú´õ ÀÌ¸§À» ¹Ù²Û µÚ ´Ù½Ã ½ÇÇàÇØ ÁÖ¼¼¿ä.
>> "%LOG_FILE%" echo   °á°ú: ½ÇÆÐ [¼³Ä¡ Æú´õ ÀÌ¹Ì Á¸Àç, °Çµå¸®Áö ¾ÊÀ½]
goto FLUTTER_FAIL_COUNT

:FLUTTER_FAIL_NOGIT
echo         [91m[½ÇÆÐ][0m Flutter+Dart - Git À» Ã£À» ¼ö ¾ø½À´Ï´Ù. Git ¼³Ä¡ ÈÄ ´Ù½Ã ½ÇÇàÇØ ÁÖ¼¼¿ä.
>> "%LOG_FILE%" echo   °á°ú: ½ÇÆÐ [Git ¾øÀ½]
goto FLUTTER_FAIL_COUNT

:FLUTTER_FAIL_CLONE
if exist "!FL_DIR!" rmdir /s /q "!FL_DIR!" >nul 2>&1
echo         [91m[½ÇÆÐ][0m Flutter+Dart ³»·Á¹Þ±â ½ÇÆÐ - ¸Þ´º [8] Á÷Á¢ ´Ù¿î·Îµå¿¡¼­ ¹ÞÀ» ¼ö ÀÖ¾î¿ä.
>> "%LOG_FILE%" echo   °á°ú: ½ÇÆÐ [git clone errorlevel=!INST_ERR!]
goto FLUTTER_FAIL_COUNT

:FLUTTER_FAIL_FIRSTRUN
echo         [91m[½ÇÆÐ][0m Flutter+Dart Ã¹ ½ÇÇà È®ÀÎ ½ÇÆÐ - »õ ÅÍ¹Ì³Î¿¡¼­ flutter --version À» ½ÇÇàÇØ º¸¼¼¿ä.
>> "%LOG_FILE%" echo   °á°ú: ½ÇÆÐ [flutter --version Ã¹ ½ÇÇà]
:FLUTTER_FAIL_COUNT
set /a FAIL_COUNT+=1
>> "%REPORT_FILE%.tmp" echo   [½ÇÆÐ] Flutter+Dart
goto :eof

:: Git ½ÇÇà ÆÄÀÏ Ã£±â: ÀÌ¹ø ½ÇÇà¿¡¼­ ¸· ¼³Ä¡µÈ Git Àº PATH ¿¡ ¾ÆÁ÷ ¾øÀ» ¼ö ÀÖ¾î ¼³Ä¡ À§Ä¡µµ È®ÀÎ
:FIND_GIT
set "FL_GIT="
where git >nul 2>&1
if not errorlevel 1 set "FL_GIT=git"
if defined FL_GIT goto :eof
if exist "%ProgramFiles%\Git\cmd\git.exe" set "FL_GIT=%ProgramFiles%\Git\cmd\git.exe"
if defined FL_GIT goto :eof
if exist "%LOCALAPPDATA%\Programs\Git\cmd\git.exe" set "FL_GIT=%LOCALAPPDATA%\Programs\Git\cmd\git.exe"
goto :eof

:: »ç¿ëÀÚ PATH ¿¡ Flutter bin Ãß°¡ [»ç¿ëÀÚ ¹üÀ§¸¸, Áßº¹ ¹æÁö, ±âÁ¸ °ª º¸Á¸, µÇµ¹¸®±â´Â [7] Á¦°Å]
:: ·¹Áö½ºÆ®¸® °ªÀ» ±×´ë·Î ÀÐ°í ¾²¹Ç·Î %USERPROFILE% °°Àº ±âÁ¸ Ç×¸ñÀÌ ±úÁöÁö ¾ÊÀ½ [setx ´Â 1024ÀÚ Àß¸² À§Çè]
:FLUTTER_PATH_ADD
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $b=$env:FL_BIN.TrimEnd('\'); $k=[Microsoft.Win32.Registry]::CurrentUser.CreateSubKey('Environment'); $p=[string]$k.GetValue('Path','',[Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames); $has=$false; foreach($e in $p.Split(';')){ if([Environment]::ExpandEnvironmentVariables($e.Trim()).TrimEnd('\') -ieq $b){ $has=$true } }; if(-not $has){ $n=($p.TrimEnd(';')+';'+$b).TrimStart(';'); $k.SetValue('Path',$n,[Microsoft.Win32.RegistryValueKind]::ExpandString); [Environment]::SetEnvironmentVariable('KIT_PATH_REFRESH','1','User'); [Environment]::SetEnvironmentVariable('KIT_PATH_REFRESH',$null,'User') }; $k.Close() } catch { exit 1 }" >nul 2>&1
if errorlevel 1 (
    echo         [¾È³»] »ç¿ëÀÚ PATH ÀÚµ¿ µî·Ï¿¡ ½ÇÆÐÇß½À´Ï´Ù. È¯°æ º¯¼ö ÆíÁý¿¡¼­ ¾Æ·¡ °æ·Î¸¦ Path ¿¡ Ãß°¡ÇØ ÁÖ¼¼¿ä.
    echo                !FL_BIN!
    >> "%LOG_FILE%" echo   PATH µî·Ï ½ÇÆÐ
) else (
    echo         [PATH] »ç¿ëÀÚ PATH ¿¡ Flutter µî·Ï È®ÀÎ - »õ ÅÍ¹Ì³Î¿¡¼­ flutter ¸í·ÉÀ» ¾µ ¼ö ÀÖ½À´Ï´Ù.
    >> "%LOG_FILE%" echo   PATH µî·Ï È®ÀÎ
)
set "PATH=!PATH!;!FL_BIN!"
goto :eof

:: Flutter Á¦°Å [Å°Æ® ¼³Ä¡ À§Ä¡¸¸. ´Ù¸¥ °÷¿¡ Á÷Á¢ ¼³Ä¡ÇÑ Flutter ´Â °Çµå¸®Áö ¾ÊÀ½]
:REMOVE_FLUTTER
if not defined USERPROFILE goto :eof
set "FL_DIR=%USERPROFILE%\develop\flutter"
set "FL_BIN=%USERPROFILE%\develop\flutter\bin"
if not exist "!FL_BIN!\flutter.bat" (
    echo  [°Ç³Ê¶Ü] Å°Æ® ¼³Ä¡ À§Ä¡¿¡ Flutter °¡ ¾ø½À´Ï´Ù. ´Ù¸¥ °÷¿¡ Á÷Á¢ ¼³Ä¡ÇÑ Flutter ´Â Áö¿ìÁö ¾Ê½À´Ï´Ù.
    goto :eof
)
echo.
echo  Flutter Æú´õ¸¦ ÅëÂ°·Î »èÁ¦ÇÕ´Ï´Ù: !FL_DIR!
set FL_DEL=
set /p FL_DEL="  1=»èÁ¦ / 2=Ãë¼Ò: "
if "!FL_DEL!"=="1" set FL_DEL=y
if /i "!FL_DEL!" NEQ "y" goto :eof
rmdir /s /q "!FL_DIR!" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $b=$env:FL_BIN.TrimEnd('\'); $k=[Microsoft.Win32.Registry]::CurrentUser.CreateSubKey('Environment'); $p=[string]$k.GetValue('Path','',[Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames); $keep=@(); foreach($e in $p.Split(';')){ if($e.Trim() -ne '' -and [Environment]::ExpandEnvironmentVariables($e.Trim()).TrimEnd('\') -ine $b){ $keep+=$e } }; $k.SetValue('Path',($keep -join ';'),[Microsoft.Win32.RegistryValueKind]::ExpandString); [Environment]::SetEnvironmentVariable('KIT_PATH_REFRESH','1','User'); [Environment]::SetEnvironmentVariable('KIT_PATH_REFRESH',$null,'User'); $k.Close() } catch { exit 1 }" >nul 2>&1
echo    Á¦°Å: Flutter [Æú´õ »èÁ¦ + »ç¿ëÀÚ PATH Á¤¸®]
>> "%LOG_FILE%" echo   Flutter Á¦°Å ¿Ï·á
goto :eof

:: ============================================================
:: [M] ¸ð¹ÙÀÏ ¾Û °³¹ß È¯°æ [Flutter ±â¹Ý ¾Èµå·ÎÀÌµå]
:: ±¸¼º: Git, Flutter, Android Studio, adb, scrcpy[¼±ÅÃ]
:: È¯°æ º¯¼ö´Â Å°Æ®°¡ ¹Ù²ÙÁö ¾Ê°í ¾È³»¸¸ ÇÑ´Ù. ¶óÀÌ¼±½º µ¿ÀÇ¿Í Android Studio Ã¹ ½ÇÇàÀº »ç¶÷ÀÌ Á÷Á¢ ÇÑ´Ù.
:: ============================================================
:DO_MOBILE
cls
echo.
echo  ===================================================
echo   [M] ¸ð¹ÙÀÏ ¾Û °³¹ß È¯°æ [Flutter / ¾Èµå·ÎÀÌµå]
echo  ===================================================
echo.
echo    [1] ¸ð¹ÙÀÏ ±âº»     Git, Flutter, Android Studio, adb   [4°³]
echo    [2] ±âº» + scrcpy   À§ 4°³ + Æù È­¸é ¹Ì·¯¸µ             [5°³]
echo    [3] °ñ¶ó¼­ ¼³Ä¡
echo    [4] ¼³Ä¡ ÈÄ ÇÒ ÀÏ ¾È³»   [Android Studio Ã¹ ½ÇÇà / ¶óÀÌ¼±½º / Æù ¿¬°á]
echo    [0] ¸ÞÀÎ ¸Þ´º·Î
echo.
echo  * µð½ºÅ© ¾à 10GB, ¼³Ä¡ ¾à 30~40ºÐ [ÀÎÅÍ³Ý ¼Óµµ¿¡ µû¶ó ´Ù¸§]
echo  * iOS ¾ÛÀº Windows ¿¡¼­ ¸¸µé ¼ö ¾ø½À´Ï´Ù [Mac ÇÊ¿ä]
echo.
set MOB_CHOICE=
set MOB_GIT=
set MOB_FL=
set MOB_STUDIO=
set MOB_ADB=
set MOB_SCRCPY=
set MOB_CHOICE=
set /p MOB_CHOICE="  ¹øÈ£: "
if "!MOB_CHOICE!"=="0" goto MAIN_MENU
if "!MOB_CHOICE!"=="1" goto MOBILE_BASIC
if "!MOB_CHOICE!"=="2" goto MOBILE_PLUS
if "!MOB_CHOICE!"=="3" goto MOBILE_PICK
if "!MOB_CHOICE!"=="4" goto MOBILE_GUIDE
goto DO_MOBILE

:MOBILE_GUIDE
cls
call :POST_MOBILE
pause
goto DO_MOBILE

:MOBILE_PLUS
set MOB_SCRCPY=1
:MOBILE_BASIC
set MOB_GIT=1
set MOB_FL=1
set MOB_STUDIO=1
set MOB_ADB=1
goto MOBILE_CONFIRM

:MOBILE_PICK
echo.
echo   [1] Git   [2] Flutter+Dart   [3] Android Studio   [4] adb   [5] scrcpy
echo   ¹øÈ£¸¦ ½°Ç¥·Î ÀÔ·ÂÇÏ¼¼¿ä  [¿¹: 2,3]      [0] µÚ·Î
set MOB_SEL=
set /p MOB_SEL="  ¹øÈ£: "
if "!MOB_SEL!"=="" goto DO_MOBILE
if "!MOB_SEL!"=="0" goto DO_MOBILE
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $ok = ($env:MOB_SEL -match '^[0-9, ]+$'); foreach($n in ($env:MOB_SEL -split '[, ]+')){ if($n -ne ''){ if([int]$n -lt 1 -or [int]$n -gt 5){ $ok = $false } } }; if($ok){ exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
if errorlevel 1 (
    echo.
    echo  [¾È³»] ¹øÈ£´Â 1ºÎÅÍ 5 »çÀÌÀÇ ¼ýÀÚ¸¸, ½°Ç¥·Î ±¸ºÐÇØ¼­ ÀÔ·ÂÇÏ¼¼¿ä. ¿¹: 2,3
    pause
    goto MOBILE_PICK
)
for %%n in (%MOB_SEL:,= %) do (
    if "%%n"=="1" set MOB_GIT=1
    if "%%n"=="2" set MOB_FL=1
    if "%%n"=="3" set MOB_STUDIO=1
    if "%%n"=="4" set MOB_ADB=1
    if "%%n"=="5" set MOB_SCRCPY=1
)

:MOBILE_CONFIRM
:: Flutter ´Â git À¸·Î ¹ÞÀ¸¹Ç·Î Git ÀÌ ¾øÀ¸¸é ÇÔ²² ¼³Ä¡
if defined MOB_FL if not defined MOB_GIT (
    call :FIND_GIT
    if not defined FL_GIT (
        echo  [¾È³»] Flutter´Â GitÀÌ ÇÊ¿äÇÕ´Ï´Ù. Gitµµ ÇÔ²² ¼³Ä¡ÇÕ´Ï´Ù.
        set MOB_GIT=1
    )
)
set TOTAL=0
if defined MOB_GIT set /a TOTAL+=1
if defined MOB_FL set /a TOTAL+=1
if defined MOB_STUDIO set /a TOTAL+=1
if defined MOB_ADB set /a TOTAL+=1
if defined MOB_SCRCPY set /a TOTAL+=1
if !TOTAL! EQU 0 goto DO_MOBILE
echo.
echo  --------------------------------------------------
echo  [¸ð¹ÙÀÏ ¼³Ä¡ ¸ñ·Ï] !TOTAL!°³
if defined MOB_GIT echo    - Git
if defined MOB_FL echo    - Flutter+Dart
if defined MOB_STUDIO echo    - Android Studio
if defined MOB_ADB echo    - adb [Android ÇÃ·§Æû µµ±¸]
if defined MOB_SCRCPY echo    - scrcpy [Æù È­¸é ¹Ì·¯¸µ]
echo  --------------------------------------------------
echo  ÀÌ¹Ì ¼³Ä¡µÈ µµ±¸´Â °Ç³Ê¶Ý´Ï´Ù. ¾÷µ¥ÀÌÆ®´Â ¸ÞÀÎ ¸Þ´º [6] À» ¾²¼¼¿ä.
echo.
set CONFIRM_MOB=
set /p CONFIRM_MOB="  1=¼³Ä¡ ½ÃÀÛ / 2=µÇµ¹¾Æ°¡±â: "
if "!CONFIRM_MOB!"=="1" set CONFIRM_MOB=y
if /i "!CONFIRM_MOB!" NEQ "y" goto DO_MOBILE
set UPGRADE_MODE=skip
set LEVEL_NAME=¸ð¹ÙÀÏ
set DISK_MIN=3
if defined MOB_FL set DISK_MIN=4
if defined MOB_STUDIO set DISK_MIN=10
set CURRENT=0
set INSTALL_COUNT=0
set SKIP_COUNT=0
set FAIL_COUNT=0
del "%REPORT_FILE%.tmp" >nul 2>&1
set PRE_CHECK_RETURN=INSTALL_MOBILE
goto PRE_CHECK

:INSTALL_MOBILE
cls
echo.
echo  [¸ð¹ÙÀÏ ¾Û °³¹ß È¯°æ ¼³Ä¡] !TOTAL!°³ µµ±¸¸¦ ¼³Ä¡ÇÕ´Ï´Ù.
echo.
>> "%LOG_FILE%" echo === ¸ð¹ÙÀÏ ¼³Ä¡ ½ÃÀÛ: %TIME% ===
call :MOBILE_VIRT_CHECK
echo.
:: ÀÇÁ¸¼º ¼ø¼­: Git, Flutter [Git ÇÊ¿ä], Android Studio, adb, scrcpy
if defined MOB_GIT call :INSTALL "Git" "Git.Git"
if defined MOB_FL call :INSTALL_FLUTTER
if defined MOB_STUDIO call :INSTALL "Android Studio" "Google.AndroidStudio"
if defined MOB_ADB call :INSTALL "adb [Android ÇÃ·§Æû µµ±¸]" "Google.PlatformTools"
if defined MOB_SCRCPY call :INSTALL "scrcpy [Æù È­¸é ¹Ì·¯¸µ]" "Genymobile.scrcpy"
call :POST_MOBILE
call :MAKE_REPORTS
call :PATH_CHECK
call :DONE_MSG
goto MAIN_MENU

:: °¡»óÈ­ È®ÀÎ [¾Èµå·ÎÀÌµå ¿¡¹Ä·¹ÀÌÅÍ¿ë]. ¾È³»¸¸ ÇÏ°í ¼³Ä¡´Â ¸·Áö ¾Ê´Â´Ù. ½ÇÁ¦ Æù ¿¬°á¿¡´Â ÇÊ¿ä ¾øÀ½.
:MOBILE_VIRT_CHECK
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $c=Get-CimInstance Win32_ComputerSystem; $p=@(Get-CimInstance Win32_Processor); if($c.HypervisorPresent -or ($p | Where-Object { $_.VirtualizationFirmwareEnabled })){ exit 0 } else { exit 1 } } catch { exit 2 }" >nul 2>&1
set VIRT_RC=!errorlevel!
if !VIRT_RC! EQU 0 (
    echo  [OK] °¡»óÈ­ »ç¿ë °¡´É - ¾Èµå·ÎÀÌµå ¿¡¹Ä·¹ÀÌÅÍ¸¦ ¾µ ¼ö ÀÖ½À´Ï´Ù
    >> "%LOG_FILE%" echo OK: °¡»óÈ­ »ç¿ë °¡´É
) else if !VIRT_RC! EQU 1 (
    echo  [¾È³»] °¡»óÈ­°¡ ²¨Á® ÀÖ½À´Ï´Ù. ¿¡¹Ä·¹ÀÌÅÍ´Â ´À¸®°Å³ª ¾È µÉ ¼ö ÀÖ½À´Ï´Ù. [½ÇÁ¦ Æù ¿¬°áÀº »ó°ü¾øÀ½]
    echo         ÄÑ·Á¸é PC ½ÃÀÛ ¶§ BIOS ¼³Á¤¿¡¼­ Intel VT-x ¶Ç´Â AMD-V ¸¦ ÄÑ¼¼¿ä.
    >> "%LOG_FILE%" echo ¾È³»: °¡»óÈ­ ²¨Áü
) else (
    echo  [¾È³»] °¡»óÈ­ »óÅÂ¸¦ È®ÀÎÇÏÁö ¸øÇß½À´Ï´Ù. ¿¡¹Ä·¹ÀÌÅÍ¿¡ ¹®Á¦°¡ ÀÖÀ¸¸é BIOS ¿¡¼­ °¡»óÈ­¸¦ ÄÑ º¸¼¼¿ä.
    >> "%LOG_FILE%" echo ¾È³»: °¡»óÈ­ È®ÀÎ ½ÇÆÐ
)
goto :eof

:: ¼³Ä¡ ÈÄ ÇÒ ÀÏ ¾È³» [ÀÚµ¿È­ÇÏÁö ¾Ê´Â ´Ü°è: ¶óÀÌ¼±½º µ¿ÀÇ / Android Studio Ã¹ ½ÇÇà / Æù ¼³Á¤]
:POST_MOBILE
echo.
echo  ---------------------------------------------------
echo  [¸ð¹ÙÀÏ ¼³Ä¡ ÈÄ ÇÒ ÀÏ - ¼ø¼­´ë·Î µû¶ó ÇÏ¼¼¿ä]
echo  ---------------------------------------------------
echo   1. Android Studio ¸¦ ÇÑ ¹ø ½ÇÇàÇÕ´Ï´Ù. [½ÃÀÛ ¸Þ´º¿¡¼­ Android Studio]
echo      ¼³Á¤ ¸¶¹ý»ç°¡ ³ª¿À¸é Standard ¸¦ °í¸£°í ³¡³¯ ¶§±îÁö ±â´Ù¸®¼¼¿ä.
echo      [Android SDK ¸¦ ³»·Á¹Þ½À´Ï´Ù. ¸î GB ¶ó¼­ ¸î ºÐ °É¸³´Ï´Ù]
echo   2. »õ ÅÍ¹Ì³ÎÀ» ¿­°í ¶óÀÌ¼±½º¿¡ µ¿ÀÇÇÕ´Ï´Ù. [Á÷Á¢ y ¸¦ ´­·¯¾ß ÇÕ´Ï´Ù]
echo        flutter doctor --android-licenses
echo   3. ÁØºñ »óÅÂ¸¦ È®ÀÎÇÕ´Ï´Ù. ¸ðµÎ Ã¼Å© Ç¥½Ã¸é ³¡ÀÔ´Ï´Ù.
echo        flutter doctor
echo      SDK ¸¦ ¸ø Ã£´Â´Ù°í ³ª¿À¸é ¾Æ·¡ ¸í·ÉÀ» ÇÑ ¹ø ½ÇÇàÇÏ¼¼¿ä.
echo        flutter config --android-sdk "%LOCALAPPDATA%\Android\Sdk"
echo   4. ½ÇÁ¦ ÆùÀ¸·Î ½ÃÇèÇÏ·Á¸é:
echo      Æù ¼³Á¤ - ÈÞ´ëÀüÈ­ Á¤º¸ - ºôµå¹øÈ£¸¦ 7¹ø ´©¸£±â - °³¹ßÀÚ ¿É¼Ç - USB µð¹ö±ë ÄÑ±â
echo      USB ·Î ¿¬°áÇÑ µÚ adb devices ¸¦ ÀÔ·ÂÇØ ÆùÀÌ º¸ÀÌ´ÂÁö È®ÀÎÇÏ¼¼¿ä.
echo   5. Æù ¾øÀÌ ½ÃÇèÇÏ·Á¸é:
echo      Android Studio - More Actions - Virtual Device Manager ¿¡¼­ °¡»ó ÆùÀ» ¸¸µå¼¼¿ä.
echo.
echo   * iOS ¾ÛÀº Windows ¿¡¼­ ¸¸µé ¼ö ¾ø½À´Ï´Ù [Mac ÇÊ¿ä].
echo   * È¯°æ º¯¼ö´Â Å°Æ®°¡ ¹Ù²ÙÁö ¾Ê½À´Ï´Ù. À§ flutter config ¸í·ÉÀ¸·Î ÃæºÐÇÕ´Ï´Ù.
echo   * adb °¡ µÎ ¹ú[Å°Æ® ¼³Ä¡ + Android Studio ³»Àå]ÀÌ¶ó ¹öÀü ºÒÀÏÄ¡ ¸Þ½ÃÁö°¡ ³ª¿À¸é
echo     adb kill-server ¸¦ ÀÔ·ÂÇÑ µÚ ´Ù½Ã ½ÃµµÇÏ¼¼¿ä.
echo.
goto :eof

:: Android Studio ¼³Ä¡ ¿©ºÎ [PATH ¿¡ ¾ø´Â ÇÁ·Î±×·¥ÀÌ¶ó ¼³Ä¡ À§Ä¡ ¶Ç´Â winget ¸ñ·ÏÀ¸·Î È®ÀÎ]
:CHECK_STUDIO
if exist "%ProgramFiles%\Android\Android Studio\bin\studio64.exe" goto CHECK_STUDIO_OK
if exist "%LOCALAPPDATA%\Programs\Android Studio\bin\studio64.exe" goto CHECK_STUDIO_OK
winget list --id Google.AndroidStudio --source winget >nul 2>&1
if not errorlevel 1 goto CHECK_STUDIO_OK
echo    [X] Android Studio
goto :eof
:CHECK_STUDIO_OK
echo    [O] Android Studio
goto :eof

:: flutter doctor ¿ä¾à [½Ã°£ÀÌ °É¸®¹Ç·Î »ç¿ëÀÚ°¡ y ¸¦ ´­·¶À» ¶§¸¸]. Á¾·áÄÚµå 0=Á¤»ó 1=°æ°í 2=¿À·ù 3=È®ÀÎ ¸øÇÔ
:FLUTTER_DOCTOR_SUMMARY
set "FD_OUT=%TEMP%\kit_flutter_doctor.txt"
echo         flutter doctor ½ÇÇà Áß... Ã³À½¿¡´Â 1~2ºÐ °É¸± ¼ö ÀÖ½À´Ï´Ù.
call flutter doctor > "!FD_OUT!" 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $t=Get-Content -LiteralPath $env:FD_OUT -Encoding UTF8 -ErrorAction Stop; if(-not $t){ exit 3 }; $c=0; foreach($l in $t){ if($l -match '^\[\x21\]'){ if($c -lt 1){ $c=1 }; Write-Host ('    '+$l) } elseif($l -match '^\[[^\]]\]' -and $l -notmatch '^\[(\u221a|\u2713)\]'){ $c=2; Write-Host ('    '+$l) } }; exit $c } catch { exit 3 }"
set FD_RC=!errorlevel!
del "!FD_OUT!" >nul 2>&1
if !FD_RC! EQU 0 (
    echo  [OK] flutter doctor: ¸ðµç Ç×¸ñ Á¤»ó - ¾Û °³¹ß ÁØºñ ¿Ï·á
) else if !FD_RC! EQU 1 (
    echo  [¾È³»] flutter doctor: °æ°í Ç×¸ñÀÌ ÀÖ½À´Ï´Ù. ¸ÞÀÎ ¸Þ´º [M] ÀÇ [4] ¼³Ä¡ ÈÄ ÇÒ ÀÏ ¾È³»¸¦ µû¶ó ÇÏ¼¼¿ä.
) else if !FD_RC! EQU 2 (
    echo  [¾È³»] flutter doctor: ¿À·ù Ç×¸ñÀÌ ÀÖ½À´Ï´Ù. ¸ÞÀÎ ¸Þ´º [M] ÀÇ [4] ¼³Ä¡ ÈÄ ÇÒ ÀÏ ¾È³»¸¦ µû¶ó ÇÏ¼¼¿ä.
) else (
    echo  [¾È³»] flutter doctor °á°ú¸¦ ÀÐÁö ¸øÇß½À´Ï´Ù. »õ ÅÍ¹Ì³Î¿¡¼­ flutter doctor ¸¦ Á÷Á¢ ½ÇÇàÇØ º¸¼¼¿ä.
)
goto :eof

:: ============================================================
:: [D] ºÐ¾ßº° °³¹ß È¯°æ Çãºê [v1.8.0]
:: À¥ / µ¥½ºÅ©Åé ¾Û / ¸ð¹ÙÀÏ[M ¿¬°á] / µ¥ÀÌÅÍ-AI-¼­¹ö / ¸¶Å©´Ù¿î ºä¾î
:: ¼±ÅÃ È­¸éÀº :PICK [À§/¾Æ·¡ È­»ìÇ¥ + Enter, ¶Ç´Â ¹øÈ£] ¸¦ »ç¿ëÇÕ´Ï´Ù.
:: ============================================================
:DO_DEV
cls
echo.
echo  ===================================================
echo   [D] ºÐ¾ßº° °³¹ß È¯°æ
echo  ===================================================
set "PICK_TITLE=¹«¾ùÀ» ¸¸µé°í ½ÍÀ¸¼¼¿ä?"
set "PICK_HINT=À§/¾Æ·¡ È­»ìÇ¥·Î ¿òÁ÷ÀÌ°í Enter ·Î ¼±ÅÃ  [¹øÈ£µµ °¡´É / 0 ¶Ç´Â Esc = µÚ·Î]"
set PICK_COUNT=5
set "PICK_1=À¥ °³¹ß              À¥ »çÀÌÆ® / À¥ ¼­ºñ½º"
set "PICK_2=µ¥½ºÅ©Åé ¾Û °³¹ß     PC ÇÁ·Î±×·¥ [Rust / Tauri]"
set "PICK_3=¸ð¹ÙÀÏ ¾Û °³¹ß       Æù ¾Û [Flutter / ¾Èµå·ÎÀÌµå]"
set "PICK_4=µ¥ÀÌÅÍ / AI / ¼­¹ö   ÆÄÀÌ½ã, AI, Docker, DB"
set "PICK_5=¸¶Å©´Ù¿î ºä¾î        .md ¹®¼­¸¦ º¸±â ÁÁ°Ô ¿­±â"
call :PICK
if "!PICK_RESULT!"=="1" goto DEV_WEB
if "!PICK_RESULT!"=="2" goto DEV_DESK
if "!PICK_RESULT!"=="3" goto DO_MOBILE
if "!PICK_RESULT!"=="4" goto DEV_DATA
if "!PICK_RESULT!"=="5" goto DO_MDVIEW
goto MAIN_MENU

:DEV_WEB
set "DEV_NAME=À¥ °³¹ß"
set "DEV_KEY=WEB"
set "DEV_BASIC_TXT=Git, Node.js, VS Code, pnpm"
set "DEV_BASIC_INFO=4°³ / ¾à 5ºÐ / µð½ºÅ© ¾à 2GB [¿¹»ó]"
set "DEV_ALL_TXT=±âº» + GitHub CLI, Bun, Vercel CLI, Supabase CLI"
set "DEV_ALL_INFO=8°³ / ¾à 10ºÐ / µð½ºÅ© ¾à 3GB [¿¹»ó]"
goto DEV_CHOOSE

:DEV_DESK
set "DEV_NAME=µ¥½ºÅ©Åé ¾Û °³¹ß"
set "DEV_KEY=DESK"
set "DEV_BASIC_TXT=Git, Node.js, VS Code, Rust, C++ ºôµå µµ±¸"
set "DEV_BASIC_INFO=5°³ / ¾à 30ºÐ / µð½ºÅ© ¾à 10GB [¿¹»ó] / C++ ºôµå µµ±¸°¡ Å©°í °ü¸®ÀÚ ±ÇÇÑÀÌ ÇÊ¿äÇÕ´Ï´Ù"
set "DEV_ALL_TXT=±âº» + GitHub CLI, pnpm"
set "DEV_ALL_INFO=7°³ / ¾à 35ºÐ / µð½ºÅ© ¾à 11GB [¿¹»ó]"
goto DEV_CHOOSE

:DEV_DATA
set "DEV_NAME=µ¥ÀÌÅÍ / AI / ¼­¹ö"
set "DEV_KEY=DATA"
set "DEV_BASIC_TXT=Python 3, uv, VS Code, Ollama"
set "DEV_BASIC_INFO=4°³ / ¾à 10ºÐ / µð½ºÅ© ¾à 2GB [¿¹»ó]"
set "DEV_ALL_TXT=±âº» + Docker Desktop, PostgreSQL"
set "DEV_ALL_INFO=6°³ / ¾à 30ºÐ / µð½ºÅ© ¾à 8GB [¿¹»ó] / °ü¸®ÀÚ ±ÇÇÑ ÇÊ¿ä, PC Àç½ÃÀÛÀÌ ÇÊ¿äÇÒ ¼ö ÀÖ½À´Ï´Ù"
goto DEV_CHOOSE

:DEV_CHOOSE
cls
echo.
echo  ===================================================
echo   [D] !DEV_NAME!
echo  ===================================================
echo.
echo    [±âº»] !DEV_BASIC_TXT!
echo           !DEV_BASIC_INFO!
echo.
echo    [ÀüºÎ] !DEV_ALL_TXT!
echo           !DEV_ALL_INFO!
echo.
echo  * ÀÌ¹Ì ¼³Ä¡µÈ µµ±¸´Â °Ç³Ê¶Ý´Ï´Ù.
set "PICK_TITLE=¼³Ä¡ ¹üÀ§¸¦ °í¸£¼¼¿ä"
set "PICK_HINT=À§/¾Æ·¡ È­»ìÇ¥·Î ¿òÁ÷ÀÌ°í Enter ·Î ¼±ÅÃ  [¹øÈ£µµ °¡´É / 0 ¶Ç´Â Esc = µÚ·Î]"
set PICK_COUNT=2
set "PICK_1=±âº»   ²À ÇÊ¿äÇÑ °Í¸¸"
set "PICK_2=ÀüºÎ   ±âº» + Ãß°¡ µµ±¸"
call :PICK
if "!PICK_RESULT!"=="0" goto DO_DEV
set DEV_MODE=!PICK_RESULT!
for %%v in (GIT NODE VSCODE PNPM GH BUN VERCEL SUPA RUST BUILD PY UV OLLAMA DOCKER PG) do set "DEV_%%v="
if "!DEV_KEY!"=="WEB" (
    set DEV_GIT=1
    set DEV_NODE=1
    set DEV_VSCODE=1
    set DEV_PNPM=1
    if "!DEV_MODE!"=="2" (
        set DEV_GH=1
        set DEV_BUN=1
        set DEV_VERCEL=1
        set DEV_SUPA=1
    )
)
if "!DEV_KEY!"=="DESK" (
    set DEV_GIT=1
    set DEV_NODE=1
    set DEV_VSCODE=1
    set DEV_RUST=1
    set DEV_BUILD=1
    if "!DEV_MODE!"=="2" (
        set DEV_GH=1
        set DEV_PNPM=1
    )
)
if "!DEV_KEY!"=="DATA" (
    set DEV_PY=1
    set DEV_UV=1
    set DEV_VSCODE=1
    set DEV_OLLAMA=1
    if "!DEV_MODE!"=="2" (
        set DEV_DOCKER=1
        set DEV_PG=1
    )
)

:: °ü¸®ÀÚ ±ÇÇÑÀÌ ÇÊ¿äÇÑ µµ±¸: C++ ºôµå µµ±¸ / Docker Desktop / PostgreSQL
set DEV_NEEDADMIN=
if defined DEV_BUILD set DEV_NEEDADMIN=1
if defined DEV_DOCKER set DEV_NEEDADMIN=1
if defined DEV_PG set DEV_NEEDADMIN=1
if defined DEV_NEEDADMIN call :ADMIN_CAPABLE
if defined DEV_NEEDADMIN if not defined ADMIN_OK (
    echo.
    echo  [ÁÖÀÇ] ÀÌ PC °èÁ¤Àº °ü¸®ÀÚ°¡ ¾Æ´Ï¶ó¼­ ¾Æ·¡ µµ±¸´Â ¼³Ä¡ÇÏÁö ¾Ê½À´Ï´Ù.
    if defined DEV_BUILD echo         - C++ ºôµå µµ±¸
    if defined DEV_DOCKER echo         - Docker Desktop
    if defined DEV_PG echo         - PostgreSQL
    echo         °ü¸®ÀÚ °èÁ¤À¸·Î ·Î±×ÀÎÇÑ µÚ ´Ù½Ã ½ÇÇàÇÏ¸é ¼³Ä¡ÇÒ ¼ö ÀÖ½À´Ï´Ù.
    set DEV_BUILD=
    set DEV_DOCKER=
    set DEV_PG=
    echo.
    pause
)

if defined DEV_DOCKER (
    echo.
    echo  ---------------------------------------------------
    echo  [Docker Desktop ¼³Ä¡ Àü¿¡ ²À ÀÐ¾î ÁÖ¼¼¿ä]
    echo  ---------------------------------------------------
    echo   1. ¼³Ä¡ ÈÄ PC ¸¦ ´Ù½Ã ½ÃÀÛÇØ¾ß ÇÒ ¼ö ÀÖ½À´Ï´Ù.
    echo   2. Ã³À½ ½ÇÇàÇÏ¸é WSL2 [À©µµ¿ì ¾ÈÀÇ ¸®´ª½º ±â´É] ¸¦ ÄÑ¶ó´Â ¾È³»°¡ ³ª¿Ã ¼ö ÀÖ½À´Ï´Ù.
    echo      °¡»óÈ­°¡ ²¨Á® ÀÖÀ¸¸é PC ½ÃÀÛ ¶§ BIOS ¿¡¼­ °¡»óÈ­¸¦ ÄÑ¾ß ÇÕ´Ï´Ù.
    echo   3. °³ÀÎ / ÇÐ½À¿ëÀº ¹«·áÀÔ´Ï´Ù. Å« È¸»ç¿¡¼­ ¾÷¹«¿ëÀ¸·Î ¾²¸é À¯·áÀÏ ¼ö ÀÖ½À´Ï´Ù.
    echo      ¾à°ü: https://www.docker.com/legal/docker-subscription-service-agreement
    echo   4. µð½ºÅ© ¾à 5GB ÀÌ»ó, ¸Þ¸ð¸® 8GB ÀÌ»óÀ» ±ÇÀåÇÕ´Ï´Ù.
    echo.
    set DOCKER_OK=
    set /p DOCKER_OK="  1=ÀÌÇØÇß°í Docker ¼³Ä¡ / 2=Docker ´Â »©°í ÁøÇà: "
    if not "!DOCKER_OK!"=="1" set DEV_DOCKER=
)

if defined DEV_PG (
    echo.
    echo  ---------------------------------------------------
    echo  [PostgreSQL ¼³Ä¡ Àü¿¡ ²À ÀÐ¾î ÁÖ¼¼¿ä]
    echo  ---------------------------------------------------
    echo   ÁÖÀÇÁ¡
    echo   1. °ü¸®ÀÚ °èÁ¤ ÀÌ¸§Àº postgres ÀÔ´Ï´Ù. Áö±Ý Á¤ÇÏ´Â ºñ¹Ð¹øÈ£´Â ÀÒ¾î¹ö¸®¸é Ã£À» ¼ö ¾øÀ¸´Ï ²À ¸Þ¸ðÇÏ¼¼¿ä.
    echo   2. ºñ¹Ð¹øÈ£´Â ¿µ¹® ´ë¼Ò¹®ÀÚ¿Í ¼ýÀÚ¸¸, 8ÀÚ ÀÌ»óÀ¸·Î Á¤ÇÏ¼¼¿ä. Æ¯¼ö¹®ÀÚ´Â ¼³Ä¡ ¿À·ùÀÇ ¿øÀÎÀÌ µË´Ï´Ù.
    echo   3. ºñ¹Ð¹øÈ£´Â ÀÌ Å°Æ®ÀÇ ·Î±×¿Í ¸®Æ÷Æ®¿¡ ÀúÀåÇÏÁö ¾Ê½À´Ï´Ù.
    echo      ´Ù¸¸ ¼³Ä¡ µµ±¸ winget ÀÌ ÀÚÃ¼ ±â·Ï¿¡ ³²±æ ¼ö ÀÖÀ¸´Ï ´Ù¸¥ °÷¿¡¼­ ¾²´Â ºñ¹Ð¹øÈ£´Â ¾²Áö ¸¶¼¼¿ä.
    echo   4. PC ¸¦ ÄÓ ¶§¸¶´Ù DB ¼­¹ö°¡ ÇÔ²² ÄÑÁý´Ï´Ù [Æ÷Æ® 5432]. ¾È ¾µ ¶§´Â ¼­ºñ½º¸¦ ÁßÁöÇÏ¼¼¿ä.
    echo   5. ³» PC ¾È¿¡¼­ ¿¬½À¿ëÀ¸·Î¸¸ ¾²¼¼¿ä. ÀÎÅÍ³Ý¿¡ °ø°³ÇÏ¸é ¾È µË´Ï´Ù.
    echo.
    set PG_OK=
    set /p PG_OK="  1=ÀÌÇØÇß°í PostgreSQL ¼³Ä¡ / 2=PostgreSQL Àº »©°í ÁøÇà: "
    if not "!PG_OK!"=="1" set DEV_PG=
)

set TOTAL=0
for %%v in (GIT NODE VSCODE PNPM GH BUN RUST BUILD PY UV OLLAMA DOCKER PG) do if defined DEV_%%v set /a TOTAL+=1
if !TOTAL! EQU 0 (
    echo.
    echo  [¾È³»] ¼³Ä¡ÇÒ µµ±¸°¡ ¾ø¾î¼­ Ã³À½ È­¸éÀ¸·Î µ¹¾Æ°©´Ï´Ù.
    pause
    goto DO_DEV
)
echo.
echo  --------------------------------------------------
echo  [!DEV_NAME! ¼³Ä¡ ¸ñ·Ï] !TOTAL!°³
if defined DEV_GIT echo    - Git
if defined DEV_NODE echo    - Node.js LTS
if defined DEV_PY echo    - Python 3
if defined DEV_UV echo    - uv
if defined DEV_VSCODE echo    - VS Code
if defined DEV_PNPM echo    - pnpm
if defined DEV_GH echo    - GitHub CLI
if defined DEV_BUN echo    - Bun
if defined DEV_OLLAMA echo    - Ollama
if defined DEV_BUILD echo    - C++ ºôµå µµ±¸
if defined DEV_RUST echo    - Rust
if defined DEV_DOCKER echo    - Docker Desktop
if defined DEV_PG echo    - PostgreSQL [ºñ¹Ð¹øÈ£¸¦ Á÷Á¢ ÀÔ·ÂÇÕ´Ï´Ù]
if defined DEV_VERCEL echo    - Vercel CLI [npm]
if defined DEV_SUPA echo    - Supabase CLI [npm]
echo  --------------------------------------------------
echo  ÀÌ¹Ì ¼³Ä¡µÈ µµ±¸´Â °Ç³Ê¶Ý´Ï´Ù. ¾÷µ¥ÀÌÆ®´Â ¸ÞÀÎ ¸Þ´º [6] À» ¾²¼¼¿ä.
echo.
set CONFIRM_DEV=
set /p CONFIRM_DEV="  1=¼³Ä¡ ½ÃÀÛ / 2=µÇµ¹¾Æ°¡±â: "
if "!CONFIRM_DEV!"=="1" set CONFIRM_DEV=y
if /i "!CONFIRM_DEV!" NEQ "y" goto DO_DEV
set UPGRADE_MODE=skip
set "LEVEL_NAME=!DEV_NAME!"
set DISK_MIN=3
if defined DEV_DOCKER set DISK_MIN=8
if defined DEV_BUILD set DISK_MIN=12
set CURRENT=0
set INSTALL_COUNT=0
set SKIP_COUNT=0
set FAIL_COUNT=0
del "%REPORT_FILE%.tmp" >nul 2>&1
set PRE_CHECK_RETURN=INSTALL_DEV
goto PRE_CHECK

:INSTALL_DEV
cls
echo.
echo  [!DEV_NAME! ¼³Ä¡] !TOTAL!°³ µµ±¸¸¦ ¼³Ä¡ÇÕ´Ï´Ù.
echo.
>> "%LOG_FILE%" echo === ºÐ¾ßº° ¼³Ä¡ ½ÃÀÛ [!DEV_NAME!]: %TIME% ===
:: ÀÇÁ¸¼º ¼ø¼­: Git, Node.js, Python °è¿­, ÆíÁý±â, ºôµå µµ±¸, Rust, Docker, DB, npm µµ±¸
if defined DEV_GIT call :INSTALL_V "Git" "Git.Git" ""
if defined DEV_NODE call :INSTALL_V "Node.js LTS" "OpenJS.NodeJS.LTS" ""
if defined DEV_PY call :INSTALL_V "Python 3" "Python.Python.3" ""
if defined DEV_UV call :INSTALL_V "uv" "astral-sh.uv" ""
if defined DEV_VSCODE call :INSTALL_V "VS Code" "Microsoft.VisualStudioCode" ""
if defined DEV_PNPM call :INSTALL_V "pnpm" "pnpm.pnpm" ""
if defined DEV_GH call :INSTALL_V "GitHub CLI" "GitHub.cli" ""
if defined DEV_BUN call :INSTALL_V "Bun" "Oven-sh.Bun" ""
if defined DEV_OLLAMA call :INSTALL_V "Ollama" "Ollama.Ollama" ""
if defined DEV_BUILD call :INSTALL_BUILDTOOLS
if defined DEV_RUST call :INSTALL_V "Rust" "Rustlang.Rustup" "FILE:%USERPROFILE%\.cargo\bin\rustc.exe"
if defined DEV_DOCKER call :INSTALL_V "Docker Desktop" "Docker.DockerDesktop" "FILE:%ProgramFiles%\Docker\Docker\Docker Desktop.exe"
if defined DEV_PG call :INSTALL_PG
if defined DEV_VERCEL call :DEV_NPM "Vercel CLI" "vercel"
if defined DEV_SUPA call :DEV_NPM "Supabase CLI" "supabase"
call :POST_DEV
call :MAKE_REPORTS
call :PATH_CHECK
call :DONE_MSG
goto MAIN_MENU

:: Node.js ¸¦ ¹æ±Ý ¼³Ä¡ÇÏ¸é ÀÌ Ã¢ÀÇ PATH ¿¡´Â ¾ÆÁ÷ npm ÀÌ ¾ø´Ù -> ±âº» ¼³Ä¡ À§Ä¡¸¦ ÀÌ Ã¢¿¡¸¸ ÀÓ½Ã·Î Ãß°¡
:DEV_NPM
if exist "%ProgramFiles%\nodejs\npm.cmd" set "PATH=%ProgramFiles%\nodejs;%PATH%"
where npm >nul 2>&1
if errorlevel 1 (
    echo         [°Ç³Ê¶Ü] %~1 : npm À» Ã£Áö ¸øÇß½À´Ï´Ù. »õ ÅÍ¹Ì³Î¿¡¼­ ¸ÞÀÎ ¸Þ´º [5] ·Î ¼³Ä¡ÇÏ¼¼¿ä.
    >> "%LOG_FILE%" echo   %~1 npm ¾øÀ½, °Ç³Ê¶Ü
    >> "%REPORT_FILE%.tmp" echo   [°Ç³Ê¶Ü] %~1 [npm ¾øÀ½]
    goto :eof
)
call :NPM_INSTALL %1 %2
goto :eof

:: °ü¸®ÀÚ °èÁ¤ ¿©ºÎ [°ü¸®ÀÚ ±×·ì ¼Ò¼ÓÀÌ¸é ¼³Ä¡ Áß ±ÇÇÑ È®ÀÎ Ã¢À¸·Î ¿Ã¸± ¼ö ÀÖÀ½]
:ADMIN_CAPABLE
set ADMIN_OK=
whoami /groups 2>nul | find "S-1-5-32-544" >nul 2>&1
if not errorlevel 1 set ADMIN_OK=1
goto :eof

:: C++ ºôµå µµ±¸[VC µµ±¸] ¼³Ä¡ ¿©ºÎ. ÀÖÀ¸¸é HAS_VC=1
:HAS_VCTOOLS
set HAS_VC=
if exist "!VSWHERE!" (
    "!VSWHERE!" -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath 2>nul | findstr /r "." >nul 2>&1
    if not errorlevel 1 set HAS_VC=1
)
goto :eof

:: Visual Studio Build Tools ´Â winget ±âº» ¼³Ä¡¸¸À¸·Î´Â C++ µµ±¸°¡ ºüÁö¹Ç·Î ¿öÅ©·Îµå¸¦ Á÷Á¢ ÁöÁ¤ÇÑ´Ù
:INSTALL_BUILDTOOLS
set /a CURRENT+=1
echo  [!CURRENT!/!TOTAL!] C++ ºôµå µµ±¸ ¼³Ä¡ Áß... [¿ë·®ÀÌ Ä¿¼­ 10~20ºÐ °É¸± ¼ö ÀÖ½À´Ï´Ù]
>> "%LOG_FILE%" echo [!CURRENT!/!TOTAL!] VS BuildTools ½ÃÀÛ: %TIME%
call :HAS_VCTOOLS
if defined HAS_VC (
    echo         [°Ç³Ê¶Ü] C++ ºôµå µµ±¸ [ÀÌ¹Ì ¼³Ä¡µÊ]
    >> "%LOG_FILE%" echo   °á°ú: °Ç³Ê¶Ü [ÀÌ¹Ì ¼³Ä¡µÊ]
    set /a SKIP_COUNT+=1
    >> "%REPORT_FILE%.tmp" echo   [°Ç³Ê¶Ü] C++ ºôµå µµ±¸
    goto :eof
)
echo         [¾È³»] °ü¸®ÀÚ ±ÇÇÑ È®ÀÎ Ã¢ÀÌ ¶ß¸é [¿¹] ¸¦ ´©¸£¼¼¿ä. ¼³Ä¡ ÁøÇà Ã¢ÀÌ µû·Î ¿­¸³´Ï´Ù.
winget install --id Microsoft.VisualStudio.2022.BuildTools --source winget --accept-source-agreements --accept-package-agreements --override "--passive --wait --norestart --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended" >nul 2>&1
set BT_RC=!errorlevel!
call :HAS_VCTOOLS
if defined HAS_VC (
    if !BT_RC! EQU 0 (
        echo         [¿Ï·á] C++ ºôµå µµ±¸
    ) else (
        echo         [¿Ï·á] C++ ºôµå µµ±¸ [PC ¸¦ ´Ù½Ã ½ÃÀÛÇØ¾ß ÇÒ ¼ö ÀÖ½À´Ï´Ù]
    )
    >> "%LOG_FILE%" echo   °á°ú: ¼º°ø [rc=!BT_RC!]
    set /a INSTALL_COUNT+=1
    >> "%REPORT_FILE%.tmp" echo   [¼º°ø] C++ ºôµå µµ±¸
    goto :eof
)
echo         [½ÇÆÐ] C++ ºôµå µµ±¸ ¼³Ä¡¸¦ È®ÀÎÇÏÁö ¸øÇß½À´Ï´Ù.
echo                Visual Studio Installer ¸¦ ¿­¾î [C++ ¸¦ »ç¿ëÇÑ µ¥½ºÅ©Åé °³¹ß] ¿¡ Ã¼Å©ÇÏ°í ¼³Ä¡ÇØ º¸¼¼¿ä.
>> "%LOG_FILE%" echo   °á°ú: ½ÇÆÐ [rc=!BT_RC!]
set /a FAIL_COUNT+=1
>> "%REPORT_FILE%.tmp" echo   [½ÇÆÐ] C++ ºôµå µµ±¸
goto :eof

:: PostgreSQL: ºñ¹Ð¹øÈ£¸¦ PowerShell ¿¡¼­ ¼û°Ü¼­ ¹Þ¾Æ ¼³Ä¡ µµ±¸¿¡ Á÷Á¢ Àü´ÞÇÑ´Ù. ÀÌ ÆÄÀÏ¿¡´Â ºñ¹Ð¹øÈ£°¡ µé¾î¿ÀÁö ¾Ê´Â´Ù.
:INSTALL_PG
set /a CURRENT+=1
echo  [!CURRENT!/!TOTAL!] PostgreSQL ¼³Ä¡ Áß...
>> "%LOG_FILE%" echo [!CURRENT!/!TOTAL!] PostgreSQL ½ÃÀÛ: %TIME%
winget list --id PostgreSQL.PostgreSQL.17 --source winget >nul 2>&1
if not errorlevel 1 (
    echo         [°Ç³Ê¶Ü] PostgreSQL [ÀÌ¹Ì ¼³Ä¡µÊ]
    >> "%LOG_FILE%" echo   °á°ú: °Ç³Ê¶Ü [ÀÌ¹Ì ¼³Ä¡µÊ]
    set /a SKIP_COUNT+=1
    >> "%REPORT_FILE%.tmp" echo   [°Ç³Ê¶Ü] PostgreSQL
    goto :eof
)
echo         PostgreSQL °ü¸®ÀÚ [postgres] ÀÇ ºñ¹Ð¹øÈ£¸¦ Á¤ÇÕ´Ï´Ù.
echo         ¿µ¹® ´ë¼Ò¹®ÀÚ¿Í ¼ýÀÚ¸¸, 8ÀÚ ÀÌ»ó. ÀÔ·ÂÇØµµ È­¸é¿¡ ±ÛÀÚ°¡ º¸ÀÌÁö ¾Ê´Â °ÍÀÌ Á¤»óÀÔ´Ï´Ù.
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s = (Get-Content -LiteralPath $env:KIT_SELF | Where-Object { $_ -like '::PG:*' } | ForEach-Object { $_.Substring(5) }) -join [Environment]::NewLine; Invoke-Expression $s"
set PG_RC=!errorlevel!
if !PG_RC! EQU 0 (
    echo         [¿Ï·á] PostgreSQL
    >> "%LOG_FILE%" echo   °á°ú: ¼º°ø
    set /a INSTALL_COUNT+=1
    >> "%REPORT_FILE%.tmp" echo   [¼º°ø] PostgreSQL
    call :VERIFY "PostgreSQL" "PostgreSQL.PostgreSQL.17" "SVC:postgresql-x64-17"
    goto :eof
)
if !PG_RC! EQU 98 (
    echo         [°Ç³Ê¶Ü] PostgreSQL : ºñ¹Ð¹øÈ£°¡ ÀÔ·ÂµÇÁö ¾Ê¾Æ ¼³Ä¡ÇÏÁö ¾Ê¾Ò½À´Ï´Ù. ´Ù½Ã ÇÏ·Á¸é ÀÌ ¸Þ´º¸¦ ´Ù½Ã ½ÇÇàÇÏ¼¼¿ä.
    >> "%LOG_FILE%" echo   °á°ú: °Ç³Ê¶Ü [ºñ¹Ð¹øÈ£ ¹ÌÀÔ·Â]
    set /a SKIP_COUNT+=1
    >> "%REPORT_FILE%.tmp" echo   [°Ç³Ê¶Ü] PostgreSQL [ºñ¹Ð¹øÈ£ ¹ÌÀÔ·Â]
    goto :eof
)
echo         [½ÇÆÐ] PostgreSQL ¼³Ä¡ ½ÇÆÐ [ÄÚµå !PG_RC!]. ¼³Ä¡ ÈÄ ¾È³»ÀÇ ¹®Á¦ ÇØ°áÀ» È®ÀÎÇÏ¼¼¿ä.
>> "%LOG_FILE%" echo   °á°ú: ½ÇÆÐ [rc=!PG_RC!]
set /a FAIL_COUNT+=1
>> "%REPORT_FILE%.tmp" echo   [½ÇÆÐ] PostgreSQL
goto :eof

:: ºÐ¾ßº° ¼³Ä¡ ÈÄ ¾È³»
:POST_DEV
if defined DEV_RUST call :RUST_NOTE
if defined DEV_BUILD (
    echo.
    echo  ---------------------------------------------------
    echo  [µ¥½ºÅ©Åé ¾Û °³¹ß ¼³Ä¡ ÈÄ ¾È³»]
    echo  ---------------------------------------------------
    echo   1. »õ ÅÍ¹Ì³ÎÀ» ¿­°í rustc --version °ú cargo --version À¸·Î È®ÀÎÇÏ¼¼¿ä.
    echo   2. C++ ºôµå µµ±¸¸¦ ¹æ±Ý ¼³Ä¡Çß´Ù¸é PC ¸¦ ÇÑ ¹ø ´Ù½Ã ½ÃÀÛÇÏ¼¼¿ä.
    echo   3. Tauri °°Àº À¥ È­¸é ±â¹Ý ¾ÛÀº WebView2 °¡ ÇÊ¿äÇÕ´Ï´Ù.
    echo      Windows 11 ¿¡´Â ±âº»À¸·Î µé¾î ÀÖ°í, Windows 10 Àº Microsoft °ø½Ä ÆäÀÌÁö¿¡¼­ ¹ÞÀ¸¼¼¿ä.
    echo   4. ºôµåÇÒ ¶§ link.exe ¸¦ ¸ø Ã£´Â´Ù´Â ¿À·ù°¡ ³ª¸é C++ ºôµå µµ±¸°¡ ºüÁø °ÍÀÔ´Ï´Ù. ÀÌ ¸Þ´º¸¦ ´Ù½Ã ½ÇÇàÇÏ¼¼¿ä.
    echo.
)
if defined DEV_OLLAMA (
    echo.
    echo  - Ollama ·ÎÄÃ AI ¸ðµ¨ ¾È³» [2GB ÀÌ»ó, Á÷Á¢ ½ÇÇà]:
    echo      ollama pull llama3.2   [¾à 2GB]
    echo.
)
if defined DEV_DOCKER (
    echo.
    echo  ---------------------------------------------------
    echo  [Docker Desktop ¼³Ä¡ ÈÄ ¾È³»]
    echo  ---------------------------------------------------
    echo   1. PC ¸¦ ´Ù½Ã ½ÃÀÛÇÑ µÚ ½ÃÀÛ ¸Þ´º¿¡¼­ Docker Desktop À» ÇÑ ¹ø ½ÇÇàÇÏ¼¼¿ä.
    echo   2. WSL2 ¸¦ ÄÑ¶ó´Â ¾È³»°¡ ³ª¿À¸é µû¸£¼¼¿ä. ¾È ÄÑÁö¸é BIOS ¿¡¼­ °¡»óÈ­¸¦ ÄÑ¾ß ÇÕ´Ï´Ù.
    echo   3. È®ÀÎ: »õ ÅÍ¹Ì³Î¿¡¼­ docker --version
    echo   4. DB ¸¦ Docker ·Î ¾²°í ½Í´Ù¸é Æ÷Æ® 5432 ¸¦ PostgreSQL °ú °°ÀÌ ¾²Áö ¸¶¼¼¿ä.
    echo.
)
if defined DEV_PG (
    echo.
    echo  ---------------------------------------------------
    echo  [PostgreSQL ¼³Ä¡ ÈÄ ¾È³» / ¹®Á¦ ÇØ°á]
    echo  ---------------------------------------------------
    echo   - Á¢¼Ó È®ÀÎ: »õ ÅÍ¹Ì³Î¿¡¼­ ¾Æ·¡ ¸í·É [ºñ¹Ð¹øÈ£´Â ¹æ±Ý Á¤ÇÑ °Í]
    echo       "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres
    echo   - ºñ¹Ð¹øÈ£¸¦ ÀØ¾ú´Ù¸é: ¼³Á¤ ÆÄÀÏÀ» °íÃÄ¾ß ÇØ¼­ ÃÊº¸ÀÚ¿¡°Ô´Â ¾î·Æ½À´Ï´Ù.
    echo       ¿¬½À¿ëÀÌ¸é Windows ¼³Á¤ - ¾Û ¿¡¼­ PostgreSQL À» »èÁ¦ÇÑ µÚ ÀÌ ¸Þ´º·Î ´Ù½Ã ¼³Ä¡ÇÏ´Â °ÍÀÌ °¡Àå ½±½À´Ï´Ù.
    echo   - ¼³Ä¡°¡ ½ÇÆÐÇß´Ù¸é: ÀÌ¹Ì ´Ù¸¥ PostgreSQL ÀÌ ¼³Ä¡µÇ¾î ÀÖ°Å³ª Æ÷Æ® 5432 ¸¦ ´Ù¸¥ ÇÁ·Î±×·¥ÀÌ ¾²°í ÀÖ´ÂÁö È®ÀÎÇÏ¼¼¿ä.
    echo   - ¾È ¾µ ¶§ ²ô±â: Windows Å° + R ¿¡¼­ services.msc ÀÔ·Â - postgresql-x64-17 - ¸¶¿ì½º ¿À¸¥ÂÊ - ÁßÁö
    echo       [½ÃÀÛ À¯ÇüÀ» ¼öµ¿À¸·Î ¹Ù²Ù¸é PC ¸¦ ÄÓ ¶§ ÀÚµ¿À¸·Î ÄÑÁöÁö ¾Ê½À´Ï´Ù]
    echo   - ³» PC ¾È¿¡¼­¸¸ ¾²¼¼¿ä. ÀÎÅÍ³Ý¿¡ °ø°³ÇÏÁö ¸¶¼¼¿ä.
    echo.
)
goto :eof

:: Rust ¾È³»: C++ ºôµå µµ±¸°¡ ¾øÀ¸¸é Rust ·Î ÇÁ·Î±×·¥À» ¸¸µé ¼ö ¾ø´Ù. ÀÖÀ¸¸é ¾Æ¹«°Íµµ º¸¿©ÁÖÁö ¾Ê´Â´Ù.
:RUST_NOTE
call :HAS_VCTOOLS
if defined HAS_VC goto :eof
echo.
echo  [Rust ¾È³»] Rust ·Î ÇÁ·Î±×·¥À» ¸¸µé·Á¸é C++ ºôµå µµ±¸°¡ µû·Î ÇÊ¿äÇÕ´Ï´Ù.
echo              ¸ÞÀÎ ¸Þ´º [D] ÀÇ µ¥½ºÅ©Åé ¾Û °³¹ß ¿¡¼­ ¼³Ä¡ÇÒ ¼ö ÀÖ½À´Ï´Ù.
echo.
goto :eof

:: ============================================================
:: ¸¶Å©´Ù¿î ºä¾î [ÇÑ ¹ø¿¡ ÇÏ³ª¾¿ °ñ¶ó¼­ ¼³Ä¡]
:: ============================================================
:DO_MDVIEW
cls
echo.
echo  ===================================================
echo   [D] ¸¶Å©´Ù¿î ºä¾î   .md ¹®¼­¸¦ º¸±â ÁÁ°Ô ¿­¾î ÁÖ´Â ÇÁ·Î±×·¥
echo  ===================================================
echo.
echo   ¸¶Å©´Ù¿î[.md] Àº AI °¡ ¸¸µé¾î ÁÖ´Â ¼³¸í¼­¿Í ±â·Ï¿¡ ¸¹ÀÌ ¾²ÀÌ´Â ¹®¼­ Çü½ÄÀÔ´Ï´Ù.
echo   ¸Þ¸ðÀåÀ¸·Î ¿­¸é ±âÈ£°¡ ¼¯¿© º¸ÀÌÁö¸¸, ºä¾î·Î ¿­¸é ±ò²ûÇÏ°Ô º¸ÀÔ´Ï´Ù.
echo.
echo    Obsidian  °¡Àå ÀÎ±â ÀÖ´Â ³ëÆ® ¾Û. ¹«·á. Æú´õÂ° ¿­¾î¼­ ¹®¼­¸¦ ¸ð¾Æ º¼ ¼ö ÀÖ½À´Ï´Ù.
echo              Ã³À½¿¡´Â ±â´ÉÀÌ ¸¹¾Æ Á¶±Ý º¹ÀâÇØ º¸ÀÏ ¼ö ÀÖ½À´Ï´Ù.
echo    MarkText  °¡Àå ´Ü¼øÇÕ´Ï´Ù. ¹«·á ¿ÀÇÂ¼Ò½º. ¾²´Â ´ë·Î ¹Ù·Î º¸±â ÁÁ°Ô ¹Ù²ò´Ï´Ù.
echo    Zettlr    ³í¹®ÀÌ³ª ±ä ±ÛÀ» ¾²±â¿¡ ÁÁ½À´Ï´Ù. ¹«·á ¿ÀÇÂ¼Ò½º.
echo    Typora    ±ò²ûÇÏÁö¸¸ À¯·áÀÔ´Ï´Ù. ¼³Ä¡ÇÏÁö ¾Ê°í °ø½Ä ÆäÀÌÁö¸¸ ¿­¾î µå¸³´Ï´Ù.
echo    VS Code   ÀÌ¹Ì ¼³Ä¡ÇÑ ÆíÁý±â·Î ¹Ì¸®º¸±â. µû·Î ¼³Ä¡ÇÏÁö ¾Ê°í ¹æ¹ý¸¸ ¾È³»ÇÕ´Ï´Ù.
set "PICK_TITLE=¼³Ä¡ÇÏ°Å³ª ¿­¾îº¼ ºä¾î¸¦ ÇÏ³ª °í¸£¼¼¿ä"
set "PICK_HINT=À§/¾Æ·¡ È­»ìÇ¥·Î ¿òÁ÷ÀÌ°í Enter ·Î ¼±ÅÃ  [¹øÈ£µµ °¡´É / 0 ¶Ç´Â Esc = µÚ·Î]"
set PICK_COUNT=5
set "PICK_1=Obsidian   ¼³Ä¡ [¹«·á]"
set "PICK_2=MarkText   ¼³Ä¡ [¹«·á]"
set "PICK_3=Zettlr     ¼³Ä¡ [¹«·á]"
set "PICK_4=Typora     °ø½Ä ÆäÀÌÁö ¿­±â [À¯·á / ¼³Ä¡ ¾È ÇÔ]"
set "PICK_5=VS Code    ¼³Ä¡ ¾øÀÌ ¹Ì¸®º¸±â ¹æ¹ý º¸±â"
call :PICK
if "!PICK_RESULT!"=="0" goto DO_DEV
if "!PICK_RESULT!"=="4" goto MD_TYPORA
if "!PICK_RESULT!"=="5" goto MD_VSCODE
if "!PICK_RESULT!"=="1" (
    set "MD_NAME=Obsidian"
    set "MD_ID=Obsidian.Obsidian"
)
if "!PICK_RESULT!"=="2" (
    set "MD_NAME=MarkText"
    set "MD_ID=MarkText.MarkText"
)
if "!PICK_RESULT!"=="3" (
    set "MD_NAME=Zettlr"
    set "MD_ID=Zettlr.Zettlr"
)
goto MD_INSTALL

:MD_TYPORA
echo.
echo  Typora ´Â À¯·á ÇÁ·Î±×·¥ÀÌ¶ó ÀÚµ¿À¸·Î ¼³Ä¡ÇÏÁö ¾Ê½À´Ï´Ù.
echo  °ø½Ä ÆäÀÌÁö¸¦ ¿±´Ï´Ù. ¹«·á Ã¼Çè ±â°£ÀÌ ³¡³ª¸é °áÁ¦°¡ ÇÊ¿äÇÒ ¼ö ÀÖÀ¸´Ï È®ÀÎÇÑ µÚ ¹ÞÀ¸¼¼¿ä.
start "" "https://typora.io/"
echo.
pause
goto DO_MDVIEW

:MD_VSCODE
cls
echo.
echo  ---------------------------------------------------
echo  [VS Code ·Î ¸¶Å©´Ù¿î ¹Ì¸®º¸±â]  [º°µµ ¼³Ä¡ ÇÊ¿ä ¾øÀ½]
echo  ---------------------------------------------------
echo   1. VS Code ¸¦ ¿±´Ï´Ù.  [¾øÀ¸¸é ¸ÞÀÎ ¸Þ´º [1] ¿ÕÃÊº¸ ¼³Ä¡¿¡ µé¾î ÀÖ½À´Ï´Ù]
echo   2. ÆÄÀÏ - ÆÄÀÏ ¿­±â ·Î .md ÆÄÀÏÀ» ¿±´Ï´Ù.
echo   3. Ctrl + Shift + V ¸¦ ´©¸£¸é º¸±â ÁÁ°Ô ¹Ù²ï ¸ð½ÀÀÌ ¿­¸³´Ï´Ù.
echo   4. ±Û°ú ¹Ì¸®º¸±â¸¦ ³ª¶õÈ÷ º¸·Á¸é Ctrl + K ¸¦ ´©¸¥ µÚ ¼ÕÀ» ¶¼°í V ¸¦ ´©¸£¼¼¿ä.
echo.
pause
goto DO_MDVIEW

:MD_INSTALL
echo.
echo  [!MD_NAME!] À» ¼³Ä¡ÇÕ´Ï´Ù.  ÀÌ¹Ì ¼³Ä¡µÇ¾î ÀÖÀ¸¸é °Ç³Ê¶Ý´Ï´Ù.
set MD_OK=
set /p MD_OK="  1=¼³Ä¡ ½ÃÀÛ / 2=µÇµ¹¾Æ°¡±â: "
if "!MD_OK!"=="1" set MD_OK=y
if /i "!MD_OK!" NEQ "y" goto DO_MDVIEW
set UPGRADE_MODE=skip
set "LEVEL_NAME=¸¶Å©´Ù¿î ºä¾î"
set DISK_MIN=2
set TOTAL=1
set CURRENT=0
set INSTALL_COUNT=0
set SKIP_COUNT=0
set FAIL_COUNT=0
del "%REPORT_FILE%.tmp" >nul 2>&1
set PRE_CHECK_RETURN=INSTALL_MD
goto PRE_CHECK

:INSTALL_MD
cls
echo.
echo  [!MD_NAME! ¼³Ä¡]
echo.
>> "%LOG_FILE%" echo === ¸¶Å©´Ù¿î ºä¾î ¼³Ä¡ ½ÃÀÛ [!MD_NAME!]: %TIME% ===
call :INSTALL_V "!MD_NAME!" "!MD_ID!" ""
call :MAKE_REPORTS
echo.
echo  ---------------------------------------------------
echo  [!MD_NAME! »ç¿ë ½ÃÀÛ]
echo   1. ½ÃÀÛ ¸Þ´º¿¡¼­ !MD_NAME! À» ¿±´Ï´Ù.
if "!MD_NAME!"=="Obsidian" echo   2. Ã³À½ È­¸é¿¡¼­ [Open folder as vault / Æú´õ¸¦ º¸°üÇÔÀ¸·Î ¿­±â] ¸¦ ´©¸£°í .md ÆÄÀÏÀÌ ÀÖ´Â Æú´õ¸¦ °í¸£¼¼¿ä.
if not "!MD_NAME!"=="Obsidian" echo   2. ¸Þ´º¿¡¼­ ÆÄÀÏ ¶Ç´Â Æú´õ ¿­±â ·Î .md ÆÄÀÏÀ» °í¸£¼¼¿ä.
echo   3. .md ÆÄÀÏÀ» ´õºíÅ¬¸¯ÇØ¼­ ¹Ù·Î ¿­°í ½Í´Ù¸é: ÆÄÀÏ ¸¶¿ì½º ¿À¸¥ÂÊ - ¿¬°á ÇÁ·Î±×·¥ - ´Ù¸¥ ¾Û ¼±ÅÃ - Ç×»ó »ç¿ë
echo  ---------------------------------------------------
echo.
pause
goto DO_MDVIEW

:: ------------------------------------------------------------
:: :PICK - À§/¾Æ·¡ È­»ìÇ¥ + Enter ¶Ç´Â ¹øÈ£·Î ÇÏ³ª °í¸£±â
:: ÀÔ·Â: PICK_TITLE, PICK_HINT, PICK_COUNT, PICK_1 ~ PICK_n  [¼±ÅÃ: PICK_DEFAULT]
:: Ãâ·Â: PICK_RESULT = 1~n,  0 = µÚ·Î [Esc / 0 / ºó Enter]
:: È­»ìÇ¥ È­¸éÀ» ¾µ ¼ö ¾ø´Â È¯°æÀÌ¸é ¹øÈ£ ÀÔ·Â ¹æ½ÄÀ¸·Î ÀÚµ¿ ÀüÈ¯ÇÕ´Ï´Ù.
:: ------------------------------------------------------------
:PICK
set PICK_RESULT=
:: È­»ìÇ¥ È­¸éÀÌ Àß ¾È µÇ´Â PC ¿¡¼­´Â KIT_NO_ARROW=1 ·Î ÄÑ µÎ¸é ¹øÈ£ ÀÔ·Â¸¸ ¾´´Ù
if defined KIT_NO_ARROW goto PICK_NUM
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s = (Get-Content -LiteralPath $env:KIT_SELF | Where-Object { $_ -like '::PS:*' } | ForEach-Object { $_.Substring(5) }) -join [Environment]::NewLine; Invoke-Expression $s"
set PICK_RC=!errorlevel!
if !PICK_RC! GEQ 0 if !PICK_RC! LEQ !PICK_COUNT! (
    set PICK_RESULT=!PICK_RC!
    goto :eof
)
:PICK_NUM
echo.
echo   !PICK_TITLE!
for /l %%i in (1,1,!PICK_COUNT!) do echo     [%%i] !PICK_%%i!
echo     [0] µÚ·Î
set PICK_IN=
set /p PICK_IN="  ¹øÈ£: "
if "!PICK_IN!"=="" (
    set PICK_RESULT=0
    goto :eof
)
for /l %%i in (0,1,!PICK_COUNT!) do if "!PICK_IN!"=="%%i" set PICK_RESULT=%%i
if not defined PICK_RESULT (
    echo.
    echo  [¾È³»] 0 ºÎÅÍ !PICK_COUNT! »çÀÌÀÇ ¹øÈ£¸¸ ÀÔ·ÂÇÏ¼¼¿ä.
    goto PICK_NUM
)
goto :eof

:: È­»ìÇ¥ ¼±ÅÃ È­¸é [PowerShell]. À§ :PICK ÀÌ ÀÌ ÆÄÀÏ¿¡¼­ ::PS: ·Î ½ÃÀÛÇÏ´Â ÁÙ¸¸ ÀÐ¾î ½ÇÇàÇÕ´Ï´Ù.
:: ÀÌ ÁÙµéÀº ¹èÄ¡ ÆÄÀÏ¿¡¼­´Â ÁÖ¼®À¸·Î ¹«½ÃµË´Ï´Ù. ¿µ¹®°ú ¼ýÀÚ¸¸ »ç¿ëÇÕ´Ï´Ù.
::PS:function Wid([string]$s) { $w = 0; foreach ($c in $s.ToCharArray()) { if ([int]$c -gt 0x2E7F) { $w += 2 } else { $w += 1 } }; return $w }
::PS:function Fit([string]$s, [int]$max) { while ((Wid $s) -gt $max) { $s = $s.Substring(0, $s.Length - 1) }; return $s }
::PS:function Show([int]$cur) {
::PS:  for ($i = 0; $i -lt $n; $i++) {
::PS:    if ($i -eq $cur) { $mark = ' > ' } else { $mark = '   ' }
::PS:    $line = Fit ($mark + [string]($i + 1) + '  ' + $items[$i]) ($maxw - 1)
::PS:    $pad = ' ' * ($maxw - 1 - (Wid $line))
::PS:    if ($i -eq $cur) { Write-Host ($line + $pad) -ForegroundColor Black -BackgroundColor Cyan } else { Write-Host ($line + $pad) }
::PS:  }
::PS:}
::PS:try {
::PS:  $test = $env:KIT_PICK_KEYS
::PS:  if (-not $test -and [Console]::IsInputRedirected) { exit 99 }
::PS:  $n = [int]$env:PICK_COUNT
::PS:  $items = @(); for ($i = 1; $i -le $n; $i++) { $items += [Environment]::GetEnvironmentVariable('PICK_' + $i) }
::PS:  $q = New-Object System.Collections.Queue
::PS:  if ($test) { foreach ($t in ($test -split ',')) { $q.Enqueue($t.Trim()) } }
::PS:  $maxw = 79
::PS:  if (-not $test) { $maxw = [Console]::WindowWidth }
::PS:  Write-Host ''
::PS:  Write-Host ('  ' + $env:PICK_TITLE)
::PS:  Write-Host ('  ' + $env:PICK_HINT)
::PS:  Write-Host ''
::PS:  $sel = 0
::PS:  if ($env:PICK_DEFAULT) { $d = [int]$env:PICK_DEFAULT - 1; if ($d -ge 0 -and $d -lt $n) { $sel = $d } }
::PS:  Show $sel
::PS:  $top = 0
::PS:  if (-not $test) { $top = [Console]::CursorTop - $n; [Console]::CursorVisible = $false }
::PS:  $result = -1
::PS:  while ($result -lt 0) {
::PS:    if ($test) { if ($q.Count -eq 0) { exit 97 }; $k = [string]$q.Dequeue() }
::PS:    else { $ki = [Console]::ReadKey($true); $k = $ki.Key.ToString(); if ([string]$ki.KeyChar -match '^[0-9]$') { $k = [string]$ki.KeyChar } }
::PS:    switch -Regex ($k) {
::PS:      '^(UpArrow|Up)$' { if ($sel -gt 0) { $sel-- } else { $sel = $n - 1 } }
::PS:      '^(DownArrow|Down)$' { if ($sel -lt $n - 1) { $sel++ } else { $sel = 0 } }
::PS:      '^(Enter|Return)$' { $result = $sel + 1 }
::PS:      '^(Escape|Esc)$' { $result = 0 }
::PS:      '^[0-9]$' { $dg = [int]$k; if ($dg -eq 0) { $result = 0 } elseif ($dg -le $n) { $sel = $dg - 1 } }
::PS:    }
::PS:    if ($result -lt 0 -and -not $test) { [Console]::SetCursorPosition(0, $top); Show $sel }
::PS:  }
::PS:  if (-not $test) { [Console]::CursorVisible = $true }
::PS:  if ($result -gt 0) { Write-Host ('  > ' + $items[$result - 1]) }
::PS:  exit $result
::PS:} catch { try { [Console]::CursorVisible = $true } catch { }; exit 99 }

:: PostgreSQL ºñ¹Ð¹øÈ£ ÀÔ·Â + ¼³Ä¡ [PowerShell]. :INSTALL_PG °¡ ::PG: ·Î ½ÃÀÛÇÏ´Â ÁÙ¸¸ ÀÐ¾î ½ÇÇàÇÕ´Ï´Ù.
:: Á¾·á ÄÚµå: 0 = ¼º°ø, 98 = ºñ¹Ð¹øÈ£ ÀÔ·Â ½ÇÆÐ [3È¸], ±× ¹Û = winget Á¾·á ÄÚµå
::PG:$ErrorActionPreference = 'Stop'
::PG:try {
::PG:  $pw = $env:KIT_TEST_PGPW
::PG:  if ($pw -and $pw -notmatch '^[A-Za-z0-9]{8,64}$') { $pw = $null }
::PG:  if (-not $pw -and [Console]::IsInputRedirected) { exit 98 }
::PG:  for ($t = 0; $t -lt 3 -and -not $pw; $t++) {
::PG:    $a = Read-Host 'Password' -AsSecureString
::PG:    $b = Read-Host 'Password again' -AsSecureString
::PG:    $pa = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($a))
::PG:    $pb = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($b))
::PG:    if ($pa -eq $pb -and $pa -match '^[A-Za-z0-9]{8,64}$') { $pw = $pa } else { Write-Host '  Not accepted: use letters and digits only, 8+ characters, and type the same twice.' }
::PG:  }
::PG:  if (-not $pw) { exit 98 }
::PG:  $ov = '--mode unattended --unattendedmodeui none --superpassword ' + $pw
::PG:  & winget install --id PostgreSQL.PostgreSQL.17 --source winget --accept-source-agreements --accept-package-agreements --override $ov | Out-Null
::PG:  exit $LASTEXITCODE
::PG:} catch { exit 98 }

:: ¼³Ä¡ »óÅÂ È®ÀÎ¿ë: winget ¸ñ·Ï¿¡ ÀÖ´ÂÁö·Î È®ÀÎ [PATH ¿¡ ¾ø´Â ÇÁ·Î±×·¥¿ë]. %~1 = Ç¥½Ã ÀÌ¸§, %~2 = winget ID
:CHECK_WG
winget list --id %~2 --source winget >nul 2>&1
if errorlevel 1 (
    echo    [X] %~1
) else (
    echo    [O] %~1
)
goto :eof

:CHECK_BUILD
call :HAS_VCTOOLS
if defined HAS_VC (
    echo    [O] C++ ºôµå µµ±¸
) else (
    echo    [X] C++ ºôµå µµ±¸
)
goto :eof

:: ============================================================
:: ¼³Ä¡ ¼º°ø ½ÇÁ¦ È®ÀÎ [ºÐ¾ßº° ¼³Ä¡ / ¸¶Å©´Ù¿î ºä¾î Àü¿ë]
:: winget ÀÌ ¼º°øÀÌ¶ó°í ÇØµµ ½ÇÁ¦·Î ¼³Ä¡µÆ´ÂÁö ÇÑ ¹ø ´õ º»´Ù. È®ÀÎÇÏÁö ¸øÇÏ¸é ¼º°øÀ¸·Î ¼¼Áö ¾Ê´Â´Ù.
:: ============================================================
:: %~1 = Ç¥½Ã ÀÌ¸§, %~2 = winget ID, %~3 = È®ÀÎ ¹æ¹ý [ºó °ª=winget ¸ñ·Ï / FILE:ÆÄÀÏ°æ·Î / SVC:¼­ºñ½ºÀÌ¸§]
:INSTALL_V
set V_BEFORE=!INSTALL_COUNT!
call :INSTALL %1 %2
if !INSTALL_COUNT! GTR !V_BEFORE! call :VERIFY %1 %2 %3
goto :eof

:VERIFY
set V_OK=
set "VK=%~3"
if "!VK!"=="" (
    winget list --id %~2 --source winget >nul 2>&1
    if not errorlevel 1 set V_OK=1
) else if "!VK:~0,5!"=="FILE:" (
    set "VP=!VK:~5!"
    if exist "!VP!" set V_OK=1
) else if "!VK:~0,4!"=="SVC:" (
    sc query "!VK:~4!" >nul 2>&1
    if not errorlevel 1 set V_OK=1
)
if defined V_OK (
    echo         [È®ÀÎ] %~1 ¼³Ä¡µÈ °ÍÀ» È®ÀÎÇß½À´Ï´Ù
    >> "%LOG_FILE%" echo   È®ÀÎ: %~1 OK
    goto :eof
)
echo         [ÁÖÀÇ] %~1 : ¼³Ä¡´Â ³¡³µ´Ù°í ³ª¿ÔÁö¸¸ ½ÇÁ¦·Î È®ÀÎÇÏÁö ¸øÇß½À´Ï´Ù.
echo                »õ ÅÍ¹Ì³ÎÀ» ¿­°í ¸ÞÀÎ ¸Þ´º [9] ¼³Ä¡ È®ÀÎÀ¸·Î ´Ù½Ã È®ÀÎÇØ º¸¼¼¿ä.
>> "%LOG_FILE%" echo   È®ÀÎ ½ÇÆÐ: %~1
set /a INSTALL_COUNT-=1
set /a FAIL_COUNT+=1
>> "%REPORT_FILE%.tmp" echo   [È®ÀÎ½ÇÆÐ] %~1 : ¼³Ä¡ ÇÁ·Î±×·¥Àº ¼º°øÀÌ¶ó°í ÇßÁö¸¸ ½ÇÁ¦·Î È®ÀÎÇÏÁö ¸øÇÔ
goto :eof

:: ============================================================
:: Á¦°Å: PostgreSQL [µ¥ÀÌÅÍ¸¦ ³²±æÁö Áö¿ïÁö Á÷Á¢ °í¸§]
:: ============================================================
:REMOVE_PG
set "PG_DATA=%ProgramFiles%\PostgreSQL\17\data"
if defined KIT_PG_DATA_DIR set "PG_DATA=!KIT_PG_DATA_DIR!"
cls
echo.
echo  ---------------------------------------------------
echo  [PostgreSQL Á¦°Å - ²À ÀÐ¾î ÁÖ¼¼¿ä]
echo  ---------------------------------------------------
echo   - PostgreSQL ÇÁ·Î±×·¥À» Á¦°ÅÇÕ´Ï´Ù. ³»°¡ ¸¸µç DB ³»¿ë[µ¥ÀÌÅÍ]Àº ¾Æ·¡ Æú´õ¿¡ µé¾î ÀÖ½À´Ï´Ù.
echo       !PG_DATA!
echo   - [ÇÁ·Î±×·¥¸¸ Á¦°Å]¸¦ °í¸£¸é µ¥ÀÌÅÍ Æú´õ´Â ±×´ë·Î ³²½À´Ï´Ù. ³ªÁß¿¡ ´Ù½Ã ¼³Ä¡ÇØµµ ±× µ¥ÀÌÅÍ¸¦ ¾µ ¼ö ÀÖ½À´Ï´Ù.
echo   - [µ¥ÀÌÅÍ±îÁö Á¦°Å]¸¦ °í¸£¸é DB ³»¿ëÀÌ ¸ðµÎ »ç¶óÁö°í µÇµ¹¸± ¼ö ¾ø½À´Ï´Ù.
echo.
echo    [1] ÇÁ·Î±×·¥¸¸ Á¦°Å   [µ¥ÀÌÅÍ´Â ³²±è / ÃßÃµ]
echo    [2] ÇÁ·Î±×·¥°ú µ¥ÀÌÅÍ ¸ðµÎ Á¦°Å   [µÇµ¹¸± ¼ö ¾øÀ½]
echo    [0] Ãë¼Ò
echo.
set PG_RM=
set /p PG_RM="  ¹øÈ£: "
if not "!PG_RM!"=="1" if not "!PG_RM!"=="2" (
    set REM_CANCEL=1
    goto :eof
)
if "!PG_RM!"=="2" (
    echo.
    echo  [¸¶Áö¸· È®ÀÎ] DB ³»¿ëÀÌ ¸ðµÎ »ç¶óÁö°í µÇµ¹¸± ¼ö ¾ø½À´Ï´Ù.
    set PG_RM2=
    set /p PG_RM2="  1=Á¤¸» µ¥ÀÌÅÍ±îÁö Á¦°Å / 2=Ãë¼Ò: "
    if not "!PG_RM2!"=="1" (
        set REM_CANCEL=1
        goto :eof
    )
)
winget uninstall --id PostgreSQL.PostgreSQL.17 --source winget --silent
if "!PG_RM!"=="2" (
    call :PG_DELETE_DATA
) else (
    if exist "!PG_DATA!\PG_VERSION" echo  [¾È³»] µ¥ÀÌÅÍ Æú´õ¸¦ ³²°å½À´Ï´Ù: !PG_DATA!
)
goto :eof

:: ¾ÈÀüÀåÄ¡: ¸¶Áö¸· Æú´õ ÀÌ¸§ÀÌ data ÀÌ°í PG_VERSION ÆÄÀÏÀÌ ÀÖ´Â PostgreSQL µ¥ÀÌÅÍ Æú´õÀÏ ¶§¸¸ Áö¿î´Ù
:PG_DELETE_DATA
for %%d in ("!PG_DATA!") do set "PG_LAST=%%~nxd"
if /i not "!PG_LAST!"=="data" (
    echo  [¾È³»] µ¥ÀÌÅÍ Æú´õ ÀÌ¸§ÀÌ ¿¹»ó°ú ´Þ¶ó ÀÚµ¿À¸·Î Áö¿ìÁö ¾Ê¾Ò½À´Ï´Ù: !PG_DATA!
    goto :eof
)
if not exist "!PG_DATA!\PG_VERSION" (
    echo  [¾È³»] Áö¿ï PostgreSQL µ¥ÀÌÅÍ Æú´õ¸¦ Ã£Áö ¸øÇß½À´Ï´Ù: !PG_DATA!
    goto :eof
)
rmdir /s /q "!PG_DATA!"
if exist "!PG_DATA!" (
    echo  [ÁÖÀÇ] µ¥ÀÌÅÍ Æú´õ¸¦ ¿ÏÀüÈ÷ Áö¿ìÁö ¸øÇß½À´Ï´Ù. Á÷Á¢ »èÁ¦ÇÏ¼¼¿ä: !PG_DATA!
) else (
    echo  [¿Ï·á] µ¥ÀÌÅÍ Æú´õ¸¦ »èÁ¦Çß½À´Ï´Ù.
)
goto :eof

:: Á¦°Å: C++ ºôµå µµ±¸ [´Ù¸¥ °³¹ß µµ±¸µµ ¾µ ¼ö ÀÖ¾î¼­ ÇÑ ¹ø ´õ È®ÀÎ]
:REMOVE_BUILDTOOLS
echo.
echo  [¾È³»] C++ ºôµå µµ±¸´Â Rust ¸»°í ´Ù¸¥ °³¹ß µµ±¸ [Visual Studio µî] µµ ¾µ ¼ö ÀÖ½À´Ï´Ù.
set BT_RM=
set /p BT_RM="  1=Á¦°Å / 2=Ãë¼Ò: "
if not "!BT_RM!"=="1" (
    set REM_CANCEL=1
    goto :eof
)
winget uninstall --id Microsoft.VisualStudio.2022.BuildTools --source winget --silent
goto :eof

:: ============================================================
:: scoop ¼³Ä¡ ÇïÆÛ (winget ¹ÌÁö¿ø -> °ø½Ä ¼³Ä¡ ½ºÅ©¸³Æ®). ·¹º§/[S] °ø¿ë, ºñ´ëÈ­Çü
:: ============================================================
:INSTALL_SCOOP
set /a CURRENT+=1
echo  [!CURRENT!/!TOTAL!] scoop ¼³Ä¡ Áß...
>> "%LOG_FILE%" echo [!CURRENT!/!TOTAL!] scoop ½ÃÀÛ: %TIME%
set "SCOOP_SHIM=%USERPROFILE%\scoop\shims\scoop.cmd"
if defined SCOOP set "SCOOP_SHIM=%SCOOP%\shims\scoop.cmd"
if exist "!SCOOP_SHIM!" (
    echo         [°Ç³Ê¶Ü] scoop [ÀÌ¹Ì ¼³Ä¡µÊ]
    >> "%LOG_FILE%" echo   °á°ú: °Ç³Ê¶Ü [scoop ÀÌ¹Ì ¼³Ä¡µÊ]
    set /a SKIP_COUNT+=1
    >> "%REPORT_FILE%.tmp" echo   [°Ç³Ê¶Ü] scoop
    goto :eof
)
where scoop >nul 2>&1
if not errorlevel 1 (
    echo         [°Ç³Ê¶Ü] scoop [ÀÌ¹Ì ¼³Ä¡µÊ]
    >> "%LOG_FILE%" echo   °á°ú: °Ç³Ê¶Ü [scoop PATH]
    set /a SKIP_COUNT+=1
    >> "%REPORT_FILE%.tmp" echo   [°Ç³Ê¶Ü] scoop
    goto :eof
)
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; Invoke-RestMethod -Uri 'https://get.scoop.sh' | Invoke-Expression } catch { exit 1 }" >nul 2>&1
if exist "!SCOOP_SHIM!" (
    echo         [¿Ï·á] scoop
    >> "%LOG_FILE%" echo   °á°ú: ¼º°ø [scoop]
    set /a INSTALL_COUNT+=1
    >> "%REPORT_FILE%.tmp" echo   [¼³Ä¡] scoop
) else (
    echo         [½ÇÆÐ] scoop ¼³Ä¡ ½ÇÆÐ - ³ªÁß¿¡ [S] ¸Þ´º¿¡¼­ Àç½Ãµµ °¡´É
    >> "%LOG_FILE%" echo   °á°ú: ½ÇÆÐ [scoop]
    set /a FAIL_COUNT+=1
    >> "%REPORT_FILE%.tmp" echo   [½ÇÆÐ] scoop
)
goto :eof

:DO_SCOOP
cls
echo.
echo  [scoop ¼³Ä¡]
echo  ---------------------------------------------------
echo.
echo   scoop Àº °³¹ß¿ë ¸í·ÉÁÙ ÆÐÅ°Áö ¸Å´ÏÀúÀÔ´Ï´Ù.
echo   winget ¸ñ·Ï¿¡ ¾ø¾î¼­ scoop °ø½Ä ¼³Ä¡ ½ºÅ©¸³Æ®¸¦ »ç¿ëÇÕ´Ï´Ù.
echo.
echo   [º¸¾È ¾È³»] get.scoop.sh ÀÇ °ø½Ä ¼³Ä¡ ½ºÅ©¸³Æ®¸¦ ÀÎÅÍ³Ý¿¡¼­ ¹Þ¾Æ ½ÇÇàÇÕ´Ï´Ù.
echo               winget °ú ´Þ¸® ¼­¸í °ËÁõÀº ¾øÀ¸¸ç, °ø½Ä ÃâÃ³¸¸ »ç¿ëÇÕ´Ï´Ù.
echo.
set "SCOOP_SHIM=%USERPROFILE%\scoop\shims\scoop.cmd"
if defined SCOOP set "SCOOP_SHIM=%SCOOP%\shims\scoop.cmd"
if exist "!SCOOP_SHIM!" (
    echo   [°Ç³Ê¶Ü] scoop Àº ÀÌ¹Ì ¼³Ä¡µÇ¾î ÀÖ½À´Ï´Ù.
    echo.
    pause
    goto MAIN_MENU
)
where scoop >nul 2>&1
if not errorlevel 1 (
    echo   [°Ç³Ê¶Ü] scoop Àº ÀÌ¹Ì ¼³Ä¡µÇ¾î ÀÖ½À´Ï´Ù.
    echo.
    pause
    goto MAIN_MENU
)
set SCOOP_OK=
set /p SCOOP_OK="  scoop À» Áö±Ý ¼³Ä¡ÇÒ±î¿ä? 1=¿¹ / 2=¾Æ´Ï¿À: "
if "!SCOOP_OK!"=="1" set SCOOP_OK=y
if /i "!SCOOP_OK!" NEQ "y" goto MAIN_MENU
echo.
echo   scoop ¼³Ä¡ Áß... 1~2ºÐ °É¸®¸ç ÀÎÅÍ³ÝÀÌ ÇÊ¿äÇÕ´Ï´Ù.
>> "%LOG_FILE%" echo scoop ¼³Ä¡ ½ÃÀÛ: %TIME%
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; Invoke-RestMethod -Uri 'https://get.scoop.sh' | Invoke-Expression } catch { exit 1 }" >nul 2>&1
if exist "!SCOOP_SHIM!" (
    echo   [¿Ï·á] scoop ¼³Ä¡ ¼º°ø. »õ ÅÍ¹Ì³ÎÀ» ¿­¸é scoop ¸í·ÉÀ» ¾µ ¼ö ÀÖ½À´Ï´Ù.
    >> "%LOG_FILE%" echo scoop ¼³Ä¡ ¼º°ø: %TIME%
) else (
    where scoop >nul 2>&1
    if not errorlevel 1 (
        echo   [¿Ï·á] scoop ¼³Ä¡ ¼º°ø.
        >> "%LOG_FILE%" echo scoop ¼³Ä¡ ¼º°ø PATH: %TIME%
    ) else (
        echo   [½ÇÆÐ] scoop ¼³Ä¡¿¡ ½ÇÆÐÇß½À´Ï´Ù.
        echo          - °ü¸®ÀÚ ±ÇÇÑÀÌ ¾Æ´Ñ ÀÏ¹Ý Ã¢¿¡¼­ ´Ù½Ã ½ÃµµÇØ º¸¼¼¿ä.
        echo          - °ø½Ä ¾È³»: https://scoop.sh
        >> "%LOG_FILE%" echo scoop ¼³Ä¡ ½ÇÆÐ: %TIME%
    )
)
echo.
pause
goto MAIN_MENU

:DO_EXIT
echo.
echo  ¹ÙÀÌºêÄÚµù È¯°æ Å°Æ®¸¦ Á¾·áÇÕ´Ï´Ù.
echo  ÁÁÀº ¹ÙÀÌºêÄÚµù µÇ¼¼¿ä!
echo.
pause
exit /b 0
