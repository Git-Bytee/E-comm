@echo off
title Check Node.js Installation
color 0E
cls
echo.
echo ========================================
echo   CHECKING NODE.JS INSTALLATION
echo ========================================
echo.

echo Checking if Node.js is installed...
echo.

node --version >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Node.js is NOT installed!
    echo.
    echo ========================================
    echo   HOW TO INSTALL NODE.JS
    echo ========================================
    echo.
    echo 1. Open your web browser
    echo 2. Go to: https://nodejs.org/
    echo 3. Click the big green "LTS" button
    echo 4. Download and install the file
    echo 5. RESTART your computer
    echo 6. Run this check again
    echo.
    echo ========================================
    echo.
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo [OK] Node.js is installed!
    echo [OK] Version: %NODE_VERSION%
    echo.
    echo ========================================
    echo   NODE.JS IS READY!
    echo ========================================
    echo.
    echo You can now start the server!
    echo.
    echo To start the server:
    echo   1. Double-click: START.bat
    echo   2. Wait for "SERVER IS RUNNING!"
    echo   3. Keep that window open
    echo.
    pause
)

