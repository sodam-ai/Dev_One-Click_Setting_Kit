@echo off
chcp 949 >nul
setlocal enabledelayedexpansion

:: ============================================================
:: ¹ÙÀÌºêÄÚµù È¯°æ Å°Æ® -- DEV-KIT.bat v1.6.2
:: AI ¹ÙÀÌºêÄÚµù ÀÔ¹®ÀÚ¸¦ À§ÇÑ ¿øÅ¬¸¯ °³¹ß È¯°æ ¼¼ÆÃ µµ±¸
:: ============================================================

:: ³¯Â¥ º¯¼ö (PowerShell·Î ·ÎÄÉÀÏ µ¶¸³Àû Ã³¸®)
for /f %%d in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd" 2^>nul') do set REPORT_DATE=%%d
if not defined REPORT_DATE set REPORT_DATE=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%

set REPORT_FILE=%~dp0install-report-%REPORT_DATE%.txt
set LOG_FILE=%~dp0install-log-%REPORT_DATE%.txt
set START_TIME=%TIME%
set UPGRADE_MODE=skip

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
echo    [8] Á÷Á¢ ´Ù¿î·Îµå  °ø½Ä »çÀÌÆ® URL ¸ñ·Ï (winget ºÒ°¡ ½Ã)
echo    [9] ¼³Ä¡ È®ÀÎ      O/X + ¹öÀü »óÅÂ Ç¥½Ã
echo    [0] Á¾·á
echo.
echo  ===========================================================
echo    [A] °¡Àå ½¬¿î ÃßÃµ ¼³Ä¡   Ã³À½ÀÌ¸é ÀÌ°Å! (±âº» 5Á¾ + AI)
echo    [V] ¹öÀü ¼±ÅÃ ¼³Ä¡        Æ¯Á¤ ¾ÈÁ¤¹öÀü (Python/Java/Ruby)
echo    [S] scoop ¼³Ä¡            °³¹ß¿ë ÆÐÅ°Áö ¸Å´ÏÀú [ºñwinget]
set /p MENU_CHOICE="  ¹øÈ£¸¦ ÀÔ·ÂÇÏ¼¼¿ä: "

if /i "!MENU_CHOICE!"=="A" goto DO_EASY
if /i "!MENU_CHOICE!"=="V" goto DO_VERSION
if /i "!MENU_CHOICE!"=="S" goto DO_SCOOP
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
        set /p CONT_WIN="  °è¼Ó ÁøÇàÇÏ½Ã°Ú½À´Ï±î? (Y/N): "
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
    set /p CONT_NET="  °è¼Ó ÁøÇàÇÏ½Ã°Ú½À´Ï±î? (Y/N): "
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
    set /p CONT_DISK="  °è¼ÓÇÏ½Ã°Ú½À´Ï±î? (y/n): "
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
set /p CONFIRM_INST="  Y=¼³Ä¡ ½ÃÀÛ / N=¸ÞÀÎ ¸Þ´º·Î: "
if /i "!CONFIRM_INST!" NEQ "y" goto MAIN_MENU
echo.
echo  ÀÌ¹Ì ¼³Ä¡µÈ µµ±¸ Ã³¸® ¹æ¹ý:
echo    [1] °Ç³Ê¶Ü    (ÇöÀç ¹öÀü À¯Áö)
echo    [2] ¾÷±×·¹ÀÌµå (ÃÖ½Å ¹öÀüÀ¸·Î)
echo    [3] Á¦°Å       (»èÁ¦¸¸)
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
set /p CONFIRM_INST="  Y=¼³Ä¡ ½ÃÀÛ / N=¸ÞÀÎ ¸Þ´º·Î: "
if /i "!CONFIRM_INST!" NEQ "y" goto MAIN_MENU
echo.
echo  ÀÌ¹Ì ¼³Ä¡µÈ µµ±¸ Ã³¸® ¹æ¹ý:
echo    [1] °Ç³Ê¶Ü    (ÇöÀç ¹öÀü À¯Áö)
echo    [2] ¾÷±×·¹ÀÌµå (ÃÖ½Å ¹öÀüÀ¸·Î)
echo    [3] Á¦°Å       (»èÁ¦¸¸)
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
set /p CONFIRM_INST="  Y=¼³Ä¡ ½ÃÀÛ / N=¸ÞÀÎ ¸Þ´º·Î: "
if /i "!CONFIRM_INST!" NEQ "y" goto MAIN_MENU
echo.
echo  ÀÌ¹Ì ¼³Ä¡µÈ µµ±¸ Ã³¸® ¹æ¹ý:
echo    [1] °Ç³Ê¶Ü    (ÇöÀç ¹öÀü À¯Áö)
echo    [2] ¾÷±×·¹ÀÌµå (ÃÖ½Å ¹öÀüÀ¸·Î)
echo    [3] Á¦°Å       (»èÁ¦¸¸)
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
set /p CONFIRM_INST="  Y=¼³Ä¡ ½ÃÀÛ / N=¸ÞÀÎ ¸Þ´º·Î: "
if /i "!CONFIRM_INST!" NEQ "y" goto MAIN_MENU
echo.
echo  ÀÌ¹Ì ¼³Ä¡µÈ µµ±¸ Ã³¸® ¹æ¹ý:
echo    [1] °Ç³Ê¶Ü    (ÇöÀç ¹öÀü À¯Áö)
echo    [2] ¾÷±×·¹ÀÌµå (ÃÖ½Å ¹öÀüÀ¸·Î)
echo    [3] Á¦°Å       (»èÁ¦¸¸)
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
:: ÀÇÁ¸¼º 5¼øÀ§: Java ÀÌÈÄ ÇÊ¼ö
call :INSTALL "Flutter+Dart" "Google.FlutterSDK"
call :INSTALL "Stripe CLI" "Stripe.StripeCLI"

call :INSTALL_SCOOP
call :POST_BEGINNER
call :POST_INTERMEDIATE
call :POST_ADVANCED
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
call :INSTALL "Flutter+Dart" "Google.FlutterSDK"
call :INSTALL "Stripe CLI" "Stripe.StripeCLI"
call :INSTALL "Ruby" "RubyInstallerTeam.RubyWithDevKit.3.3"
call :INSTALL "PHP" "PHP.PHP"

call :INSTALL_SCOOP
call :POST_BEGINNER
call :POST_INTERMEDIATE
call :POST_ADVANCED
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

echo         [°Ç³Ê¶Ü] %~1 (npm ¼³Ä¡ ½ÇÆÐ)
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
echo         [91m[°Ç³Ê¶Ü][0m %~1 ¼³Ä¡ ½ÇÆÐ - °ÆÁ¤¸¶¼¼¿ä! ¸Þ´º [8] Á÷Á¢ ´Ù¿î·Îµå¿¡¼­ ¹ÞÀ» ¼ö ÀÖ¾î¿ä.
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
        echo  [°Ç³Ê¶Ü] Claude Code CLI ¼³Ä¡ ½ÇÆÐ - ÀÎÅÍ³Ý È®ÀÎ ÈÄ npm install -g @anthropic-ai/claude-code ·Î Àç½Ãµµ
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
set /p INST_VERCEL="  Vercel CLI ¼³Ä¡ÇÒ±î¿ä? (y/n): "
if /i "!INST_VERCEL!"=="y" call :NPM_INSTALL "Vercel CLI" "vercel"
set /p INST_SUPABASE="  Supabase CLI ¼³Ä¡ÇÒ±î¿ä? (y/n): "
if /i "!INST_SUPABASE!"=="y" call :NPM_INSTALL "Supabase CLI" "supabase"
set /p INST_STRIPE="  Stripe SDK ¼³Ä¡ÇÒ±î¿ä? (y/n): "
if /i "!INST_STRIPE!"=="y" call :NPM_INSTALL "Stripe SDK" "stripe"
set /p INST_RESEND="  Resend SDK ¼³Ä¡ÇÒ±î¿ä? (y/n): "
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
    echo  ÀÌ ÆÄÀÏÀ» °­»ç¿¡°Ô Àü´ÞÇÏ¸é ¼³Ä¡ »óÅÂ¸¦ ÆÄ¾ÇÇÒ ¼ö ÀÖ½À´Ï´Ù.
    echo ====================================================
) > "%REPORT_FILE%"

del "%REPORT_FILE%.tmp" >nul 2>&1

>> "%LOG_FILE%" echo.
>> "%LOG_FILE%" echo === ¼³Ä¡ ¿Ï·á: %END_TIME% ===
>> "%LOG_FILE%" echo ¼º°ø: %INSTALL_COUNT% / °Ç³Ê¶Ü: %SKIP_COUNT% / ½ÇÆÐ: %FAIL_COUNT%

echo.
echo  [¸®Æ÷Æ® ÀúÀå ¿Ï·á] ¾Æ·¡ ÆÄÀÏÀ» °­»ç¿¡°Ô Àü´ÞÇØ ÁÖ¼¼¿ä:
echo    %REPORT_FILE%  (°­»ç¿ë ¿ä¾à)
echo    %LOG_FILE%     (µð¹ö±ë¿ë »ó¼¼)
goto :eof

:: ============================================================
:: PATH °ËÁõ Ãâ·Â (¼³Ä¡ ¿Ï·á ÈÄ ´«À¸·Î È®ÀÎ)
:: ============================================================
:PATH_CHECK
echo.
echo  ---------------------------------------------------
echo  [PATH °ËÁõ] ÇöÀç ÅÍ¹Ì³Î¿¡¼­ ÀÎ½ÄµÇ´Â µµ±¸
echo  ---------------------------------------------------
for %%c in (git python node npm pnpm bun go rustc rustup flutter dart java gh pwsh ruby php) do (
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
    echo         %LOG_FILE% ¸¦ °­»ç¿¡°Ô Àü´ÞÇÏ¼¼¿ä.
    echo.
)
echo  ¼³Ä¡°¡ ¿Ï·áµÇ¾ú½À´Ï´Ù!
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
set /p CONFIRM_EASY="  Y=¼³Ä¡ ½ÃÀÛ / N=¸ÞÀÎ ¸Þ´º·Î: "
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
set /p SEL="  ¹øÈ£ ÀÔ·Â: "
if "!SEL!"=="0" goto MAIN_MENU
if "!SEL!"=="" set SEL=1,2,3,4,5

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
)
echo  ---------------------------------------------------
set /p CONFIRM_SEL="  Y=¼³Ä¡ ½ÃÀÛ / N=´Ù½Ã ¼±ÅÃ: "
if /i "!CONFIRM_SEL!" NEQ "y" goto DO_SELECT
echo.
echo  ÀÌ¹Ì ¼³Ä¡µÈ µµ±¸ Ã³¸® ¹æ¹ý:
echo    [1] °Ç³Ê¶Ü    (ÇöÀç ¹öÀü À¯Áö)
echo    [2] ¾÷±×·¹ÀÌµå (ÃÖ½Å ¹öÀüÀ¸·Î)
echo    [3] Á¦°Å       (»èÁ¦¸¸)
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

:: Flutter(12) -> Java 21 ¼±Çà ¼³Ä¡
echo !SEL! | findstr /C:"12" >nul 2>&1
if not errorlevel 1 (
    where java >nul 2>&1
    if errorlevel 1 (
        echo  [¾È³»] Flutter´Â Java 21ÀÌ ÇÊ¿äÇÕ´Ï´Ù. ¸ÕÀú ¼³Ä¡ÇÕ´Ï´Ù.
        set /a TOTAL+=1
        call :INSTALL "Java 21 LTS" "EclipseAdoptium.Temurin.21.JDK"
    )
)

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
    if "%%n"=="12" call :INSTALL "Flutter+Dart" "Google.FlutterSDK"
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
)

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
set /p DO_UPD="  Å°Æ® µµ±¸¸¦ ¾ÈÀüÇÏ°Ô ¾÷µ¥ÀÌÆ®ÇÒ±î¿ä? (y/n): "
if /i "!DO_UPD!" NEQ "y" goto MAIN_MENU
echo.
for %%p in (Git.Git GitHub.GitLFS Python.Python.3 OpenJS.NodeJS.LTS GitHub.cli Microsoft.PowerShell pnpm.pnpm Oven-sh.Bun Ollama.Ollama Microsoft.VisualStudioCode Microsoft.WindowsTerminal EclipseAdoptium.Temurin.21.JDK GoLang.Go Rustlang.Rustup Google.FlutterSDK Stripe.StripeCLI RubyInstallerTeam.RubyWithDevKit.3.3 PHP.PHP EclipseAdoptium.Temurin.17.JDK EclipseAdoptium.Temurin.11.JDK EclipseAdoptium.Temurin.8.JDK Python.Python.3.13 Python.Python.3.12 Python.Python.3.11 RubyInstallerTeam.RubyWithDevKit.3.2) do (
    winget upgrade --id %%p --source winget --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    if not errorlevel 1 echo  [¾÷±×·¹ÀÌµå] %%p
)

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
echo  [0] µÚ·Î
echo.
set /p REM_SEL="  ¹øÈ£: "
if "!REM_SEL!"=="0"  goto DO_REMOVE

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
if "!REM_SEL!"=="12" winget uninstall --id Google.FlutterSDK --source winget --silent
if "!REM_SEL!"=="13" winget uninstall --id GoLang.Go --source winget --silent
if "!REM_SEL!"=="14" winget uninstall --id Rustlang.Rustup --source winget --silent
if "!REM_SEL!"=="15" winget uninstall --id RubyInstallerTeam.RubyWithDevKit.3.3 --source winget --silent
if "!REM_SEL!"=="15" winget uninstall --id RubyInstallerTeam.RubyWithDevKit.3.2 --source winget --silent >nul 2>&1
if "!REM_SEL!"=="16" winget uninstall --id PHP.PHP --source winget --silent
if "!REM_SEL!"=="17" winget uninstall --id GitHub.GitLFS --source winget --silent
if "!REM_SEL!"=="18" winget uninstall --id Stripe.StripeCLI --source winget --silent
if "!REM_SEL!"=="19" winget uninstall --id astral-sh.uv --source winget --silent

echo.
echo  [¿Ï·á] Á¦°Å ¿Ï·á.
pause
goto MAIN_MENU

:REMOVE_ALL
echo.
echo  [°æ°í] ÀÌ Å°Æ®·Î ¼³Ä¡ÇÑ ¸ðµç µµ±¸¸¦ Á¦°ÅÇÕ´Ï´Ù.
set /p REM_ALL_CONFIRM="  Y¸¦ ÀÔ·ÂÇÏ¸é ÁøÇàÇÕ´Ï´Ù: "
if /i "!REM_ALL_CONFIRM!" NEQ "y" goto DO_REMOVE

echo  Á¦°Å Áß... (½Ã°£ÀÌ °É¸± ¼ö ÀÖ½À´Ï´Ù)
for %%i in (
    astral-sh.uv
    GitHub.GitLFS
    Stripe.StripeCLI
    PHP.PHP
    RubyInstallerTeam.RubyWithDevKit.3.3
    RubyInstallerTeam.RubyWithDevKit.3.2
    Google.FlutterSDK
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
echo   --- °³¹ß È®Àå CLI ---
echo    [20] GitHub LFS        https://git-lfs.com/
echo    [21] Stripe CLI        https://docs.stripe.com/stripe-cli
echo.
echo  ---------------------------------------------------
echo    [0] ¸ÞÀÎ ¸Þ´º·Î
echo.
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
set /p SCOOP_OK="  scoop À» Áö±Ý ¼³Ä¡ÇÒ±î¿ä? [Y/N]: "
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
