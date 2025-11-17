@echo off
title EasyCart Server - Port 3000
color 0A
cls
echo.
echo ========================================
echo   EASYCART SERVER - PORT 3000
echo ========================================
echo.

cd /d "%~dp0"

REM Check Node.js
where node >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js not found!
    echo Please install from: https://nodejs.org/
    pause
    exit /b 1
)

echo [OK] Node.js found
echo.

REM Set environment
set MYSQL_HOST=localhost
set MYSQL_USER=root
set MYSQL_PASSWORD=
set MYSQL_DATABASE=easycart_db
set PORT=3000

echo [INFO] Starting server on port 3000...
echo.

REM Install deps if needed
if not exist "node_modules" (
    echo [INFO] Installing dependencies...
    call npm install
)

echo.
echo ========================================
echo   SERVER STARTING...
echo ========================================
echo.
echo Keep this window open!
echo.
echo.

node src/index.js

pause

