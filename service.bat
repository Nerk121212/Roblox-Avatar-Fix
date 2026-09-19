@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
title Roblox Avatar Fix
color 0B
set "ADDON=%~dp0"
set "LISTS=%ADDON%lists"
set "EXCLUDE=%LISTS%\list-exclude-user.txt"
set "GENERAL=%LISTS%\list-general-user.txt"
set "AUTOCLOSE_FILE=%ADDON%autoclose.cfg"
set "MODE_FILE=%ADDON%mode.cfg"

fltmc >nul 2>&1
if errorlevel 1 (
    powershell.exe -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs -WorkingDirectory '%~dp0'"
    exit /b
)

if not exist "%LISTS%" md "%LISTS%"
if not exist "%ADDON%toggle-alt.ps1" goto :missing
if not exist "%ADDON%update-hosts.ps1" goto :missing
if not exist "%EXCLUDE%" type nul > "%EXCLUDE%"
if not exist "%GENERAL%" type nul > "%GENERAL%"

set "AUTOCLOSE=ON"
if exist "%AUTOCLOSE_FILE%" set /p AUTOCLOSE=<"%AUTOCLOSE_FILE%"
if /i not "!AUTOCLOSE!"=="OFF" set "AUTOCLOSE=ON"

set "MODE=SAFE"
if exist "%MODE_FILE%" set /p MODE=<"%MODE_FILE%"
if /i not "!MODE!"=="RAGE" set "MODE=SAFE"

:menu
cls
set "ENABLED=0"
set "HAS_HOSTS=0"
if exist "%SystemRoot%\System32\drivers\etc\hosts" (
    findstr /c:"# === ROBLOX AVATAR FIX HOSTS BEGIN ===" "%SystemRoot%\System32\drivers\etc\hosts" >nul 2>&1
    if not errorlevel 1 set "HAS_HOSTS=1"
)
if /i "!MODE!"=="RAGE" (
    findstr /c:"# === ROBLOX AVATAR ALT_FIX BEGIN ===" "%GENERAL%" >nul 2>&1
    if not errorlevel 1 if "!HAS_HOSTS!"=="1" set "ENABLED=1"
) else (
    findstr /c:"# === ROBLOX AVATAR FIX BEGIN ===" "%EXCLUDE%" >nul 2>&1
    if not errorlevel 1 if "!HAS_HOSTS!"=="1" set "ENABLED=1"
)
set "STATUS=DISABLED"
if "!ENABLED!"=="1" set "STATUS=ENABLED"

if /i "!MODE!"=="RAGE" (set "MODE_LABEL=RAGE") else (set "MODE_LABEL=SAFE")

echo.
echo  ===========================================================
echo                    ROBLOX AVATAR FIX
echo  ===========================================================
echo.
echo      Status      : !STATUS!
echo      Mode        : !MODE_LABEL!
echo      AutoClose   : !AUTOCLOSE!
echo.
echo      [1] Enable Avatar Fix
echo      [2] Disable Avatar Fix
echo      [3] Refresh Status
echo      [4] Toggle AutoClose
echo      [5] Toggle ALT_FIX mode
echo      [0] Exit
echo.
echo  ===========================================================
echo.
choice /c 123450 /n /m "  Select: "
set "CHOICE=!errorlevel!"
if "!CHOICE!"=="1" goto :enable
if "!CHOICE!"=="2" goto :disable
if "!CHOICE!"=="3" goto :menu
if "!CHOICE!"=="4" goto :toggle_autoclose
if "!CHOICE!"=="5" goto :toggle_altfix
if "!CHOICE!"=="6" goto :exit_app
goto :menu

:enable
cls
echo.
echo Enabling Roblox Avatar Fix...
if /i "!MODE!"=="RAGE" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%toggle-alt.ps1" -Action ON
) else (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%toggle-alt.ps1" -Action OFF
)
if errorlevel 1 goto :enable_error
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%update-hosts.ps1" -Action ON
if errorlevel 1 goto :enable_error
echo.
echo [OK] Roblox Avatar Fix ENABLED
if /i "!AUTOCLOSE!"=="OFF" pause
goto :menu

:enable_error
echo.
echo [ERROR] Avatar Fix could not be enabled.
pause
goto :menu

:disable
cls
echo.
echo Disabling Roblox Avatar Fix...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%toggle-alt.ps1" -Action REMOVE
if errorlevel 1 goto :disable_error
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%update-hosts.ps1" -Action OFF
if errorlevel 1 goto :disable_error
echo.
echo [OK] Roblox Avatar Fix DISABLED
if /i "!AUTOCLOSE!"=="OFF" pause
goto :menu

:disable_error
echo.
echo [ERROR] Avatar Fix could not be disabled.
pause
goto :menu

:toggle_autoclose
if /i "!AUTOCLOSE!"=="ON" (set "AUTOCLOSE=OFF") else (set "AUTOCLOSE=ON")
>"%AUTOCLOSE_FILE%" echo(!AUTOCLOSE!
goto :menu

:toggle_altfix
if /i "!MODE!"=="RAGE" (
    set "MODE=SAFE"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%toggle-alt.ps1" -Action OFF
) else (
    set "MODE=RAGE"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%toggle-alt.ps1" -Action ON
)
if errorlevel 1 goto :altfix_error
>"%MODE_FILE%" echo(!MODE!

goto :menu

:altfix_error
echo.
echo [ERROR] ALT_FIX mode could not be changed.
pause
goto :menu

:missing
echo [ERROR] Required files are missing.
pause
goto :exit_app

:exit_app
exit /b 0
