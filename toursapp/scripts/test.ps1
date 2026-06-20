# Sync F→D rồi chạy flutter test
param(
    [string]$FlutterRoot = "D:\Thanh\Projects\ToursApp\toursapp",
    [string]$Filter = ""
)

# 1. Sync
& "$PSScriptRoot\sync.ps1"
if ($LASTEXITCODE -gt 1) { Write-Host "Sync had errors." -ForegroundColor Yellow }

# 2. Test
Write-Host "`nRunning flutter test..." -ForegroundColor Cyan
Set-Location $FlutterRoot

if ($Filter) {
    flutter test --name $Filter
} else {
    flutter test
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nAll tests passed." -ForegroundColor Green
} else {
    Write-Host "`nTests FAILED." -ForegroundColor Red
    exit 1
}
