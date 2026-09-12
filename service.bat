@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"

set "ADDON=%~dp0"
set "ROOT=%~dp0..\"
set "LISTS=%ROOT%lists\"
if not exist "%ROOT%bin\winws.exe" if exist "%ADDON%lists\" (
    set "ROOT=%ADDON%"
    set "LISTS=%ADDON%lists\"
)
set "EXCLUDE=%LISTS%list-exclude-user.txt"
set "HOSTS=%SystemRoot%\System32\drivers\etc\hosts"
set "AUTOCLOSE_FILE=%ADDON%autoclose.cfg"

fltmc >nul 2>&1
if errorlevel 1 (
    if exist "%ADDON%run-as-admin.vbs" (
        wscript.exe //nologo "%ADDON%run-as-admin.vbs" "%~f0"
        exit /b
    )
    echo [ERROR] Administrator rights are required.
    pause
    exit /b 1
)

if not exist "%LISTS%" md "%LISTS%" >nul 2>&1
if not exist "%ADDON%update-list.ps1" goto :missing
if not exist "%ADDON%update-hosts.ps1" goto :missing
if not exist "%ADDON%remove-list.ps1" goto :missing

set "AUTOCLOSE=ON"
if exist "%AUTOCLOSE_FILE%" set /p AUTOCLOSE=<"%AUTOCLOSE_FILE%"
if /i not "%AUTOCLOSE%"=="OFF" set "AUTOCLOSE=ON"

goto :menu

:menu
@echo off
cls
set "STATUS=DISABLED"
if exist "%EXCLUDE%" (
    findstr /c:"# === ROBLOX AVATAR FIX BEGIN ===" "%EXCLUDE%" >nul 2>&1
    if not errorlevel 1 set "STATUS=ENABLED"
) else (
    set "STATUS=NO LIST FILE"
)
if exist "%HOSTS%" (
    findstr /c:"# === ROBLOX AVATAR FIX HOSTS BEGIN ===" "%HOSTS%" >nul 2>&1
    if not errorlevel 1 if /i "!STATUS!"=="DISABLED" set "STATUS=PARTIAL"
)

@echo.
@echo =========================================
@echo        ROBLOX AVATAR FIX
@echo =========================================
@echo.
@echo    Status: !STATUS!
@echo.
@echo    1. Enable Avatar Fix
@echo    2. Disable Avatar Fix
@echo    3. Check Status
@echo    4. AutoClose [!AUTOCLOSE!]
@echo    0. Exit
@echo.
@choice /c 12340 /n /m "Select: "
set "MENU_CHOICE=%errorlevel%"
if "!MENU_CHOICE!"=="5" exit /b 0
if "!MENU_CHOICE!"=="4" goto :toggle_autoclose
if "!MENU_CHOICE!"=="3" goto :menu
if "!MENU_CHOICE!"=="2" goto :disable
if "!MENU_CHOICE!"=="1" goto :enable
goto :menu

:enable
@echo off
cls
@echo Enabling Roblox Avatar Fix...
if not exist "%LISTS%" (
    @echo [ERROR] Lists folder not found.
    pause
    goto :menu
)
if not exist "%EXCLUDE%" @echo # Created by Roblox Avatar Fix>"%EXCLUDE%"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%update-list.ps1" -Path "%EXCLUDE%"
if errorlevel 1 goto :enable_error
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%update-hosts.ps1" ON
if errorlevel 1 goto :enable_error

@echo.
@echo [OK] Roblox Avatar Fix ENABLED
@echo.
if /i "!AUTOCLOSE!"=="ON" goto :menu
pause
goto :menu

:enable_error
@echo.
@echo [ERROR] Avatar Fix could not be enabled.
pause
goto :menu

:disable
@echo off
cls
@echo Disabling Roblox Avatar Fix...
if exist "%EXCLUDE%" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%remove-list.ps1" -Path "%EXCLUDE%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%update-hosts.ps1" OFF
if errorlevel 1 goto :disable_error

@echo.
@echo [OK] Roblox Avatar Fix DISABLED
@echo.
if /i "!AUTOCLOSE!"=="ON" goto :menu
pause
goto :menu

:disable_error
@echo.
@echo [ERROR] Avatar Fix could not be disabled.
pause
goto :menu

:toggle_autoclose
@echo off
if /i "!AUTOCLOSE!"=="ON" (
    set "AUTOCLOSE=OFF"
) else (
    set "AUTOCLOSE=ON"
)
>"%AUTOCLOSE_FILE%" echo !AUTOCLOSE!
goto :menu

:missing
@echo [ERROR] Required files are missing.
pause
exit /b 1
