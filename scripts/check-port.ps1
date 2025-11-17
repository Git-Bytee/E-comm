# Check if port 3000 is available
Write-Host "Checking if port 3000 is available..." -ForegroundColor Yellow

$port = 3000
$connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue

if ($connection) {
    Write-Host "✗ Port 3000 is already in use!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Process using port 3000:" -ForegroundColor Yellow
    $process = Get-Process -Id $connection.OwningProcess -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "  Process Name: $($process.ProcessName)" -ForegroundColor White
        Write-Host "  Process ID: $($process.Id)" -ForegroundColor White
        Write-Host ""
        $kill = Read-Host "Kill this process? (Y/N)"
        if ($kill -eq 'Y' -or $kill -eq 'y') {
            Stop-Process -Id $process.Id -Force
            Write-Host "✓ Process killed. Port 3000 is now available." -ForegroundColor Green
        }
    }
} else {
    Write-Host "✓ Port 3000 is available!" -ForegroundColor Green
}

Write-Host ""

