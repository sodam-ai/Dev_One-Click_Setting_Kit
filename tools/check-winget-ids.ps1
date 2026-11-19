<#
  check-winget-ids.ps1  -  READ-ONLY check. Installs NOTHING.

  Purpose : find package IDs in dev-one-click-setting-kit.bat that no longer exist
            (the bug that made "Python.Python.3" and "PHP.PHP" fail silently).
  What it does:
    1) collects every winget ID used by the bat (install / uninstall / upgrade lists)
    2) `winget show --id <ID> --exact`   -> exit code 0 means the ID exists
       (exit code, not text, so it also works on non-Korean Windows)
    3) HEAD-requests the installer URL    -> HTTP 200 means the download is alive
    4) `npm view <pkg> version`           -> npm package exists
  Exit code: 0 = all good, 1 = at least one problem.

  Usage : powershell -NoProfile -ExecutionPolicy Bypass -File tools\check-winget-ids.ps1
          (optional)  -Bat <path-to-bat>   -SkipUrl   -SkipNpm
  Run it before every release.
#>
param(
    [string]$Bat = (Join-Path (Split-Path -Parent $PSScriptRoot) 'dev-one-click-setting-kit.bat'),
    [switch]$SkipUrl,
    [switch]$SkipNpm
)

$ErrorActionPreference = 'Continue'

function Find-Tool([string]$name, [string[]]$extra) {
    $c = Get-Command $name -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($c) { return $c.Source }
    foreach ($p in $extra) { if ($p -and (Test-Path $p)) { return $p } }
    return $null
}

$winget = Find-Tool 'winget' @("$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe")
if (-not $winget) { Write-Host '[ERROR] winget not found on this PC.'; exit 1 }
if (-not (Test-Path $Bat)) { Write-Host "[ERROR] bat not found: $Bat"; exit 1 }

# the bat is CP949 (Korean ANSI) - decode with that so nothing is lost
$text = [IO.File]::ReadAllText($Bat, [Text.Encoding]::GetEncoding(949))

$idPattern = '^[A-Za-z][A-Za-z0-9-]*(\.[A-Za-z0-9+-]+)+$'
$ids = New-Object System.Collections.Generic.HashSet[string] ([StringComparer]::OrdinalIgnoreCase)

foreach ($m in [regex]::Matches($text, 'call :INSTALL\w* "[^"]*" "([^"]+)"')) { [void]$ids.Add($m.Groups[1].Value) }
foreach ($m in [regex]::Matches($text, '--id ([A-Za-z0-9][A-Za-z0-9._+-]*)'))   { [void]$ids.Add($m.Groups[1].Value) }
foreach ($m in [regex]::Matches($text, '(?m)^\s*set VER_ID=(\S+)'))              { [void]$ids.Add($m.Groups[1].Value) }
foreach ($m in [regex]::Matches($text, 'for %%\w in \(([^)]*)\) do')) {
    foreach ($t in ($m.Groups[1].Value -split '\s+')) { if ($t) { [void]$ids.Add($t) } }
}
$idList = @($ids | Where-Object { $_ -match $idPattern -and $_ -notmatch '^%' } | Sort-Object)

$npmPkgs = New-Object System.Collections.Generic.HashSet[string]
foreach ($m in [regex]::Matches($text, 'call :NPM_INSTALL "[^"]*" "([^"]+)"')) { [void]$npmPkgs.Add($m.Groups[1].Value) }
foreach ($m in [regex]::Matches($text, 'npm install -g (@?[A-Za-z0-9][A-Za-z0-9/._-]*)')) { if ($m.Groups[1].Value -notmatch '^%') { [void]$npmPkgs.Add($m.Groups[1].Value) } }

Write-Host ("winget IDs found in bat: {0}   npm packages: {1}" -f $idList.Count, $npmPkgs.Count)
Write-Host '(read-only: nothing is installed)'
Write-Host ''

$bad = 0
foreach ($id in $idList) {
    $out = & $winget show --id $id --exact --source winget --accept-source-agreements 2>&1 | Out-String
    $caseNote = ''
    if ($LASTEXITCODE -ne 0) {
        # the bat installs WITHOUT --exact (case-insensitive match), so mirror that before declaring failure
        $out = & $winget show --id $id --source winget --accept-source-agreements 2>&1 | Out-String
        if ($LASTEXITCODE -ne 0) {
            Write-Host ("[MISSING] {0}  - not in the winget catalog (install would FAIL)" -f $id)
            $bad++
            continue
        }
        $caseNote = ' [warn: letter-case differs from catalog ID, works but not canonical]'
    }
    $state = 'OK'
    if (-not $SkipUrl) {
        $m = [regex]::Match($out, '(?im):\s*(https?://\S+\.(?:exe|msi|msix|msixbundle|appx|zip))(?=\s|$)')
        if ($m.Success) {
            $url = $m.Groups[1].Value
            $code = $null
            try { $code = [int](Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing -TimeoutSec 25).StatusCode }
            catch {
                try { $code = [int](Invoke-WebRequest -Uri $url -Headers @{ Range = 'bytes=0-0' } -UseBasicParsing -TimeoutSec 25).StatusCode }
                catch { $code = 0 }
            }
            if ($code -ge 200 -and $code -lt 400) { $state = "OK (download HTTP $code)" }
            else { $state = "URL-BAD (HTTP $code) $url"; $bad++ }
        } else { $state = 'OK (installer URL not parsed - id exists only)' }
    }
    $tag = if ($state -like 'URL-BAD*') { '[URL-BAD]' } elseif ($caseNote) { '[warn]' } else { '[ok]' }
    Write-Host ("{0} {1}  {2}{3}" -f $tag, $id, $state, $caseNote)
}

if (-not $SkipNpm) {
    $npm = Find-Tool 'npm.cmd' @()
    if (-not $npm) { $npm = Find-Tool 'npm' @() }
    if (-not $npm) { Write-Host '[skip] npm not found - npm packages not checked' }
    else {
        foreach ($p in ($npmPkgs | Sort-Object)) {
            $v = (& $npm view $p version 2>&1 | Out-String).Trim()
            if ($LASTEXITCODE -eq 0 -and $v) { Write-Host ("[ok] npm {0}  {1}" -f $p, ($v -split "`n")[0]) }
            else { Write-Host ("[MISSING] npm {0}" -f $p); $bad++ }
        }
    }
}

Write-Host ''
if ($bad -eq 0) { Write-Host 'RESULT: PASS - every ID exists and every download answered.'; exit 0 }
Write-Host ("RESULT: FAIL - {0} problem(s) above. Fix the bat before release." -f $bad)
exit 1
