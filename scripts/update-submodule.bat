@echo off
setlocal enableextensions enabledelayedexpansion

REM Wrapper to run the PowerShell submodule update script for 'langgraph'
set PS_SCRIPT=%~dp0update-submodule.ps1

if not exist "%PS_SCRIPT%" (
  echo PowerShell script not found: %PS_SCRIPT%
  exit /b 1
)

powershell -ExecutionPolicy Bypass -File "%PS_SCRIPT%" -SubmodulePath "langgraph" -SubmoduleBranch "main" -Remote "origin"
set ERR=%ERRORLEVEL%
if %ERR% NEQ 0 (
  echo Update failed with exit code %ERR%
  exit /b %ERR%
)

echo Submodule update completed.
exit /b 0
