@echo off
title Server Diagnostics
color 0E
cls
echo.
echo ========================================
echo   SERVER DIAGNOSTICS
echo ========================================
echo.

echo [1] Checking Node.js...
where node >nul 2>&1
if errorlevel 1 (
    echo     [FAIL] Node.js not found!
    echo     Please install from: https://nodejs.org/
) else (
    for /f "tokens=*" %%i in ('node --version') do echo     [OK] Node.js: %%i
)
echo.

echo [2] Checking npm...
where npm >nul 2>&1
if errorlevel 1 (
    echo     [FAIL] npm not found!
) else (
    for /f "tokens=*" %%i in ('npm --version') do echo     [OK] npm: %%i
)
echo.

echo [3] Checking port 3000...
netstat -ano | findstr :3000 >nul 2>&1
if errorlevel 1 (
    echo     [OK] Port 3000 is available
) else (
    echo     [WARNING] Port 3000 is in use!
    echo     Processes using port 3000:
    netstat -ano | findstr :3000
)
echo.

echo [4] Checking server files...
if exist "src\index.js" (
    echo     [OK] Server file exists
) else (
    echo     [FAIL] src\index.js not found!
)
if exist "package.json" (
    echo     [OK] package.json exists
) else (
    echo     [FAIL] package.json not found!
)
echo.

echo [5] Checking dependencies...
if exist "node_modules" (
    echo     [OK] node_modules folder exists
) else (
    echo     [WARNING] node_modules not found - run: npm install
)
echo.

echo [6] Testing server connection...
curl -s http://localhost:3000/api/test >nul 2>&1
if errorlevel 1 (
    echo     [INFO] Server is not running (this is OK if you haven't started it)
) else (
    echo     [OK] Server is responding!
    curl -s http://localhost:3000/api/test
    echo.
)
echo.

echo ========================================
echo   DIAGNOSTICS COMPLETE
echo ========================================
echo.
pause

