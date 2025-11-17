@echo off
echo Testing server connection...
echo.

curl http://localhost:3000/api/test
echo.
echo.

if errorlevel 1 (
    echo [FAIL] Server is NOT running!
    echo.
    echo To start the server:
    echo   1. Go to: E-comm\server
    echo   2. Double-click: RUN.bat
    echo   3. Wait for "Connection successful!"
    echo   4. Run this test again
) else (
    echo [SUCCESS] Server is running on port 3000!
)

echo.
pause

