@echo off
title RDP Launcher

:: Request admin if needed
echo Requesting Admin

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Fix working dir

cd /d "%~dp0"

echo Running as Admin 

:: Move to GUI script

cd "src"

cd "ahk"

:: Start GUI Script

start "" "GUI.ahk"