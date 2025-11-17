# EasyCart Server Startup Script for PowerShell
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  EasyCart Server Startup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Node.js
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ ERROR: Node.js is not installed or not in PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Node.js from: https://nodejs.org/" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

# Set environment variables
$env:MYSQL_HOST = "localhost"
$env:MYSQL_USER = "root"
$env:MYSQL_DATABASE = "easycart_db"
$env:JWT_SECRET = "dev_secret_change_me"
$env:PORT = "3000"  # Force port 3000

Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  MySQL Host: $env:MYSQL_HOST"
Write-Host "  MySQL User: $env:MYSQL_USER"
Write-Host "  Database: $env:MYSQL_DATABASE"
Write-Host "  Server Port: $env:PORT"
Write-Host ""

# Prompt for MySQL password
Write-Host "MySQL Password:" -ForegroundColor Yellow
Write-Host "  (Enter your MySQL root password, or press Enter if no password)" -ForegroundColor Gray
$passwordInput = Read-Host "  Password"
if ([string]::IsNullOrWhiteSpace($passwordInput)) {
    $env:MYSQL_PASSWORD = ""
    Write-Host "  Using empty password" -ForegroundColor Gray
} else {
    $env:MYSQL_PASSWORD = $passwordInput
    Write-Host "  Password set" -ForegroundColor Gray
}

# Check if port 3000 is available
Write-Host "Checking port 3000..." -ForegroundColor Yellow
$portCheck = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
if ($portCheck) {
    Write-Host "⚠ WARNING: Port 3000 is already in use!" -ForegroundColor Yellow
    $process = Get-Process -Id $portCheck.OwningProcess -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "  Process: $($process.ProcessName) (PID: $($process.Id))" -ForegroundColor White
        Write-Host "  You may need to close this process first." -ForegroundColor White
    }
    Write-Host ""
    $continue = Read-Host "Continue anyway? (Y/N)"
    if ($continue -ne 'Y' -and $continue -ne 'y') {
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "✓ Port 3000 is available" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installing/updating dependencies..." -ForegroundColor Yellow
npm install --silent
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "✗ ERROR: Failed to install dependencies" -ForegroundColor Red
    Write-Host "  Try running: npm install" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "✓ Dependencies installed" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Server..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠ IMPORTANT:" -ForegroundColor Yellow
Write-Host "  1. Make sure MySQL is running" -ForegroundColor White
Write-Host "  2. Keep this window open while using the website" -ForegroundColor White
Write-Host "  3. Press Ctrl+C to stop the server" -ForegroundColor White
Write-Host ""
Write-Host "Server will start on: http://localhost:3000" -ForegroundColor Cyan
Write-Host ""

# Start the server
node src/index.js

