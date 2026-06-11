::echo off
powershell -ExecutionPolicy Bypass -Command "Get-ChildItem -Path . -Recurse | Unblock-File -ErrorAction SilentlyContinue"
powershell -ExecutionPolicy Bypass -File "%~dp0start.ps1"