@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
set "ADDON=%~dp0"
set "ROOT=%ADDON%"
set "LISTS=%ADDON%lists\"
if exist "%ADDON%..\lists\" if exist "%ADDON%..\bin\" (
    set "ROOT=%ADDON%..\"
    set "LISTS=%ROOT%lists\"
)
set "EXCLUDE=%LISTS%list-exclude-user.txt"
set "HOSTS=%SystemRoot%\System32\drivers\etc\hosts"
set "AUTOCLOSE_FILE=%ADDON%autoclose.cfg"
fltmc >nul 2>&1
if errorlevel 1 (
    powershell.exe -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs -WorkingDirectory '%~dp0'"
    exit /b
)
if not exist "%LISTS%" md "%LISTS%" >nul 2>&1
if not exist "%ADDON%update-list.ps1" goto :missing
if not exist "%ADDON%update-hosts.ps1" goto :missing
if not exist "%ADDON%remove-list.ps1" goto :missing
if not exist "%EXCLUDE%" (
    >"%EXCLUDE%" echo # Created by Roblox Avatar Fix
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%update-list.ps1" -Path "%EXCLUDE%" >nul 2>&1
)
set "AUTOCLOSE=ON"
if exist "%AUTOCLOSE_FILE%" set /p AUTOCLOSE=<"%AUTOCLOSE_FILE%"
if /i not "%AUTOCLOSE%"=="OFF" set "AUTOCLOSE=ON"
goto :menu
:menu
cls
set "STATUS=DISABLED"
if exist "%EXCLUDE%" (
    findstr /c:"# === ROBLOX AVATAR FIX BEGIN ===" "%EXCLUDE%" >nul 2>&1
    if not errorlevel 1 set "STATUS=ENABLED"
) else set "STATUS=REPAIRING"
if exist "%HOSTS%" (
    findstr /c:"# === ROBLOX AVATAR FIX HOSTS BEGIN ===" "%HOSTS%" >nul 2>&1
    if not errorlevel 1 if /i "!STATUS!"=="DISABLED" set "STATUS=PARTIAL"
)
echo.
echo =========================================
echo        ROBLOX AVATAR FIX
echo =========================================
echo.
echo    Status: !STATUS!
echo.
echo    1. Enable Avatar Fix
echo    2. Disable Avatar Fix
echo    3. Check Status
echo    4. AutoClose [!AUTOCLOSE!]
echo    0. Exit
echo.
choice /c 12340 /n /m "Select: "
set "MENU_CHOICE=%errorlevel%"
if "!MENU_CHOICE!"=="5" exit /b 0
if "!MENU_CHOICE!"=="4" goto :toggle_autoclose
if "!MENU_CHOICE!"=="3" goto :menu
if "!MENU_CHOICE!"=="2" goto :disable
if "!MENU_CHOICE!"=="1" goto :enable
goto :menu
:enable
cls
echo Enabling Roblox Avatar Fix...
if not exist "%LISTS%" md "%LISTS%" >nul 2>&1
if not exist "%EXCLUDE%" echo # Created by Roblox Avatar Fix>"%EXCLUDE%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%update-list.ps1" -Path "%EXCLUDE%"
if errorlevel 1 goto :enable_error
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%update-hosts.ps1" ON
if errorlevel 1 goto :enable_error
echo.
echo [OK] Roblox Avatar Fix ENABLED
if /i "!AUTOCLOSE!"=="ON" exit /b 0
pause
goto :menu
:enable_error
echo.
echo [ERROR] Avatar Fix could not be enabled.
echo Check that the Lists folder and PowerShell files are present.
pause
goto :menu
:disable
cls
echo Disabling Roblox Avatar Fix...
if exist "%EXCLUDE%" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%remove-list.ps1" -Path "%EXCLUDE%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%update-hosts.ps1" OFF
if errorlevel 1 goto :disable_error
echo.
echo [OK] Roblox Avatar Fix DISABLED
if /i "!AUTOCLOSE!"=="ON" exit /b 0
pause
goto :menu
:disable_error
echo.
echo [ERROR] Avatar Fix could not be disabled.
pause
goto :menu
:toggle_autoclose
if /i "!AUTOCLOSE!"=="ON" (
    set "AUTOCLOSE=OFF"
) else (
    set "AUTOCLOSE=ON"
)
>"%AUTOCLOSE_FILE%" echo(!AUTOCLOSE!
goto :menu
:missing
echo [ERROR] Required files are missing.
echo Make sure update-list.ps1, update-hosts.ps1 and remove-list.ps1 are beside service.bat.
pause
exit /b 1
