# Sync F→D rồi chạy build_runner (codegen cho freezed, riverpod, drift, retrofit)
param(
    [string]$FlutterRoot = "D:\Thanh\Projects\ToursApp\toursapp"
)

# 1. Sync
& "$PSScriptRoot\sync.ps1"
if ($LASTEXITCODE -gt 1) { Write-Host "Sync had errors." -ForegroundColor Yellow }

# 2. Run build_runner
Write-Host "`nRunning build_runner..." -ForegroundColor Cyan
Set-Location $FlutterRoot
flutter pub run build_runner build --delete-conflicting-outputs

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nCodegen done." -ForegroundColor Green

    # Sync generated files back to F: (*.g.dart, *.freezed.dart)
    Write-Host "Copying generated files back to F:..." -ForegroundColor Cyan
    robocopy $FlutterRoot "F:\Jimmii\Projects\ToursApp\toursapp" /MIR `
        /XD ".dart_tool" "build" ".vscode" "scripts" `
        /XF "*.log" "analyze.txt" `
        /NFL /NDL /NJH /NJS /nc /ns /np
    Write-Host "Sync back done." -ForegroundColor Green
} else {
    Write-Host "`nCodegen FAILED." -ForegroundColor Red
    exit 1
}
