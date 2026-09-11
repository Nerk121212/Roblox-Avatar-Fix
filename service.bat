@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion

set "ROOT=%~dp0"
set "LISTS=%ROOT%lists"
set "LIST=%LISTS%\list-exclude-user.txt"
set "HOSTS=%SystemRoot%\System32\drivers\etc\hosts"
set "PS1=%ROOT%update-avatar-fix.ps1"

if not exist "%LISTS%" md "%LISTS%" >nul 2>&1
if not exist "%PS1%" goto :missing_ps1

:menu
cls
call :status
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
echo    0. Exit
echo.
choice /c 1230 /n /m "Select: "

if errorlevel 4 exit /b
if errorlevel 3 goto :menu
if errorlevel 2 goto :disable
if errorlevel 1 goto :enable
goto :menu

:enable
cls
echo Enabling Roblox Avatar Fix...
set "ADDON=%~dp0"
set "ROOT=%ADDON%..\"
set "LISTS=%ROOT%lists\"
if not exist "%ROOT%bin\winws.exe" if exist "%ADDON%lists\" set "ROOT=%ADDON%"&set "LISTS=%ADDON%lists\"
set "EXCLUDE=%LISTS%list-exclude-user.txt"
fltmc >nul 2>&1
if errorlevel 1 (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)
if not exist "%LISTS%" (
  echo [ERROR] Lists folder not found: %LISTS%
  pause
  goto :menu
)
if not exist "%EXCLUDE%" >"%EXCLUDE%" echo # Created by Roblox Avatar Fix
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%update-list.ps1" -Path "%EXCLUDE%"
if errorlevel 1 goto :avatar_enable_err
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%update-hosts.ps1" ON
if errorlevel 1 goto :avatar_enable_err
echo.
echo [OK] Roblox Avatar Fix ENABLED
echo [OK] list-exclude-user.txt updated
echo [OK] tr.rbxcdn.com hosts entries added
echo [OK] DNS servers were NOT changed.
echo.
echo Restart your normal zapret BAT once if needed to reload lists.
pause
goto :menu

:avatar_enable_err
echo [ERROR] Avatar Fix could not be enabled.
pause
goto :menu

:disable
cls
echo Disabling Roblox Avatar Fix...
set "ADDON=%~dp0"
set "ROOT=%ADDON%..\"
set "LISTS=%ROOT%lists\"
if not exist "%ROOT%bin\winws.exe" if exist "%ADDON%lists\" set "ROOT=%ADDON%"&set "LISTS=%ADDON%lists\"
set "EXCLUDE=%LISTS%list-exclude-user.txt"
fltmc >nul 2>&1
if errorlevel 1 (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)
if exist "%EXCLUDE%" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%remove-list.ps1" -Path "%EXCLUDE%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ADDON%update-hosts.ps1" OFF
if errorlevel 1 goto :avatar_disable_err
echo.
echo [OK] Roblox Avatar Fix DISABLED
echo [OK] Only this add-on block was removed.
echo [OK] DNS servers were NOT changed.
echo.
echo Restart your normal zapret BAT once if needed to reload lists.
pause
goto :menu

:avatar_disable_err
echo [ERROR] Avatar Fix could not be disabled.
pause
goto :menu

:status
set "STATUS=DISABLED"
set "ADDON=%~dp0"
set "ROOT=%ADDON%..\"
set "LISTS=%ROOT%lists\"
if not exist "%ROOT%bin\winws.exe" if exist "%ADDON%lists\" set "ROOT=%ADDON%"&set "LISTS=%ADDON%lists\"
set "EXCLUDE=%LISTS%list-exclude-user.txt"
if exist "%EXCLUDE%" (
    findstr /c:"# === ROBLOX AVATAR FIX BEGIN ===" "%EXCLUDE%" >nul 2>&1
    if not errorlevel 1 set "STATUS=ENABLED"
) else (
    set "STATUS=NO LIST FILE"
)
if exist "%SystemRoot%\System32\drivers\etc\hosts" (
    findstr /c:"# === ROBLOX AVATAR FIX HOSTS BEGIN ===" "%SystemRoot%\System32\drivers\etc\hosts" >nul 2>&1
    if not errorlevel 1 (
        if "!STATUS!"=="DISABLED" set "STATUS=PARTIAL"
    )
)
exit /b

:missing_ps1
echo [ERROR] Required PowerShell helper is missing.
echo Please keep update-list.ps1, remove-list.ps1 and update-hosts.ps1 next to service.bat.
pause
exit /b 1

:missing_ps1
echo [ERROR] update-avatar-fix.ps1 is missing:
echo %PS1%
pause
exit /b 1
