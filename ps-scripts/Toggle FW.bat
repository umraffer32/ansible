@echo off
setlocal

:: --- self-elevate ---
net session >nul 2>&1
if %errorlevel% neq 0 (
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Start-Process -FilePath '%ComSpec%' -Verb RunAs -ArgumentList '/c','\"%~f0\"'"
  exit /b
)

:: --- toggle + nicer output ---
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "Write-Host 'Checking Firewall State..';" ^
  "$anyOn = (Get-NetFirewallProfile | Where-Object Enabled -eq 'True').Count -gt 0;" ^
  "Write-Host ('Firewall is ' + ($(if($anyOn){'ON'} else {'OFF'})));" ^
  "$target = if($anyOn){'False'} else {'True'};" ^
  "Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled $target;" ^
  "Write-Host ('Firewall is now ' + ($(if($anyOn){'OFF'} else {'ON'})) + ' (all profiles)');"

:: --- refresh the Firewall UI (reopen it) ---
taskkill /im mmc.exe /f >nul 2>&1
start "" wf.msc


