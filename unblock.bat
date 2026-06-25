@echo off
setlocal enabledelayedexpansion
set "DIR=%~dp0"
for %%f in ("install.ps1" "start.ps1" "unblock.ps1") do (
    set "file=!DIR!%%~f"
    if exist "!file!" (
        del /f /q "!file!:Zone.Identifier" 2>nul
    )
)
echo Done.
pause