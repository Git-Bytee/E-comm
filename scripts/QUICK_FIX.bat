@echo off
title Quick Fix - Server Startup
color 0B
cls
echo.
echo ========================================
echo   QUICK FIX - Starting Server
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] Checking Node.js...
where node >nul 2>&1
if errorlevel 1 (
    echo     [FAIL] Node.js not installed!
    echo     Please install from: https://nodejs.org/
    pause
    exit /b 1
)
node --version
echo     [OK] Node.js found
echo.

echo [2/4] Checking port 3000...
netstat -ano | findstr :3000 >nul 2>&1
if not errorlevel 1 (
    echo     [WARNING] Port 3000 is in use!
    echo     Finding process...
    netstat -ano | findstr :3000
    echo.
    set /p kill="Kill process? (Y/N): "
    if /i "%kill%"=="Y" (
        for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000') do (
            taskkill /PID %%a /F >nul 2>&1
        )
        echo     [OK] Process killed
    )
) else (
    echo     [OK] Port 3000 is available
)
echo.

echo [3/4] Installing dependencies...
if not exist "node_modules" (
    call npm install
    if errorlevel 1 (
        echo     [FAIL] npm install failed!
        pause
        exit /b 1
    )
) else (
    echo     [OK] Dependencies already installed
)
echo.

echo [4/4] Starting server...
echo.
echo ========================================
echo   SERVER STARTING...
echo ========================================
echo.
echo Keep this window open!
echo.
echo.

node src/index.js

if errorlevel 1 (
    echo.
    echo ========================================
    echo   SERVER FAILED TO START
    echo ========================================
    echo.
    echo Check the error message above.
    echo.
    echo Common fixes:
    echo   1. Make sure Node.js is installed
    echo   2. Run: npm install
    echo   3. Check if port 3000 is free
    echo.
    pause
)

