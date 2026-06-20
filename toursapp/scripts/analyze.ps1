# Sync F→D rồi chạy flutter analyze, ghi kết quả ra analyze.txt
param(
    [string]$FlutterRoot = "D:\Thanh\Projects\ToursApp\toursapp"
)

# 1. Sync
& "$PSScriptRoot\sync.ps1"
if ($LASTEXITCODE -gt 1) { Write-Host "Sync had errors." -ForegroundColor Yellow }

# 2. Analyze
Write-Host "`nRunning flutter analyze..." -ForegroundColor Cyan
Set-Location $FlutterRoot
flutter analyze 2>&1 | Tee-Object -FilePath "$PSScriptRoot\..\analyze.txt" -Encoding utf8

# Copy analyze.txt back to F: edit root
Copy-Item "$PSScriptRoot\..\analyze.txt" "F:\Jimmii\Projects\ToursApp\toursapp\analyze.txt" -Force
Write-Host "Results saved to analyze.txt" -ForegroundColor Green
