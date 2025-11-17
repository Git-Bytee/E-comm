@echo off
title EasyCart Server
color 0A
cls
echo.
echo ========================================
echo   EASYCART SERVER - PORT 3000
echo ========================================
echo.

cd /d "%~dp0"

echo Checking Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js not found!
    echo Download from: https://nodejs.org/
    pause
    exit
)

echo Node.js OK
echo.

echo Installing dependencies...
call npm install --silent
echo Dependencies OK
echo.

echo Starting server on port 3000...
echo.

REM Check if MySQL password needs to be set
if "%MYSQL_PASSWORD%"=="" (
    echo [INFO] MySQL password not set (using empty password)
    echo [INFO] If you have a MySQL password, edit this file and set MYSQL_PASSWORD
)

echo.
echo ========================================
echo   SERVER RUNNING - KEEP WINDOW OPEN!
echo ========================================
echo.
echo If you see "Database not ready" error:
echo   1. Make sure MySQL is running
echo   2. Run: setup-database.bat
echo   3. Or see: SETUP_DATABASE_MANUAL.md
echo.

set MYSQL_HOST=localhost
set MYSQL_USER=root
set MYSQL_PASSWORD=
set MYSQL_DATABASE=easycart_db
set PORT=3000

node src/index.js

pause
