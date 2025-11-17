@echo off
title EasyCart Server - Port 3000
color 0A
echo.
echo ========================================
echo   EasyCart Server - Starting...
echo ========================================
echo.

REM Change to server directory
cd /d "%~dp0"

REM Check Node.js
where node >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js is not installed!
    echo.
    echo Please install Node.js from: https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo [OK] Node.js found
echo.

REM Set environment variables
set MYSQL_HOST=localhost
set MYSQL_USER=root
set MYSQL_PASSWORD=
set MYSQL_DATABASE=easycart_db
set JWT_SECRET=dev_secret_change_me
set PORT=3000

echo [INFO] Configuration:
echo   Port: 3000
echo   Database: easycart_db
echo.

REM Install dependencies
echo [INFO] Installing dependencies...
call npm install
if errorlevel 1 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [OK] Dependencies installed
echo.

REM Check port 3000
netstat -ano | findstr :3000 >nul 2>&1
if not errorlevel 1 (
    echo [WARNING] Port 3000 is already in use!
    echo.
    echo Please close the application using port 3000
    echo Or run: netstat -ano ^| findstr :3000
    echo.
    pause
)

echo.
echo ========================================
echo   Starting server on port 3000...
echo ========================================
echo.
echo [IMPORTANT] Keep this window open!
echo [IMPORTANT] Server will run on: http://localhost:3000
echo.
echo Press Ctrl+C to stop the server
echo.

REM Start server
node src/index.js

if errorlevel 1 (
    echo.
    echo [ERROR] Server failed to start!
    echo.
    pause
)

