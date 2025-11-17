@echo off
title Setup Database
color 0B
cls
echo.
echo ========================================
echo   SETUP MYSQL DATABASE
echo ========================================
echo.

echo This will create the database and tables.
echo.

REM Check if MySQL is available
where mysql >nul 2>&1
if errorlevel 1 (
    echo [WARNING] MySQL command not found in PATH
    echo.
    echo You can still set up the database manually:
    echo   1. Open MySQL Workbench or MySQL Command Line
    echo   2. Run the SQL commands from: auth_user.sql
    echo.
    pause
    exit /b 1
)

echo [INFO] MySQL found!
echo.

set /p MYSQL_USER="Enter MySQL username (default: root): "
if "%MYSQL_USER%"=="" set MYSQL_USER=root

set /p MYSQL_PASSWORD="Enter MySQL password (press Enter if no password): "

echo.
echo Creating database and tables...
echo.

if "%MYSQL_PASSWORD%"=="" (
    mysql -u %MYSQL_USER% -e "CREATE DATABASE IF NOT EXISTS easycart_db;"
    mysql -u %MYSQL_USER% easycart_db < "%~dp0..\auth_user.sql"
) else (
    mysql -u %MYSQL_USER% -p%MYSQL_PASSWORD% -e "CREATE DATABASE IF NOT EXISTS easycart_db;"
    mysql -u %MYSQL_USER% -p%MYSQL_PASSWORD% easycart_db < "%~dp0..\auth_user.sql"
)

if errorlevel 1 (
    echo.
    echo [ERROR] Database setup failed!
    echo.
    echo Try manual setup:
    echo   1. Open MySQL Workbench
    echo   2. Connect to your MySQL server
    echo   3. Run: CREATE DATABASE IF NOT EXISTS easycart_db;
    echo   4. Select easycart_db database
    echo   5. Run the SQL from: E-comm\auth_user.sql
    echo.
) else (
    echo.
    echo [SUCCESS] Database setup complete!
    echo.
    echo Now restart your server (START.bat)
    echo.
)

pause

