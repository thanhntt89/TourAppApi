# Sync F: (edit) → D: (Flutter SDK) — chỉ copy file đã thay đổi
param(
    [string]$Src = "F:\Jimmii\Projects\ToursApp\toursapp",
    [string]$Dst = "D:\Thanh\Projects\ToursApp\toursapp"
)

if (-not (Test-Path $Dst)) {
    Write-Host "ERROR: Dst not found: $Dst" -ForegroundColor Red
    exit 1
}

Write-Host "Syncing $Src → $Dst ..." -ForegroundColor Cyan
robocopy $Src $Dst /MIR /XD ".dart_tool" "build" ".vscode" "android_backup_*" /XF "*.log" "analyze.txt" /NFL /NDL /NJH /NJS /nc /ns /np
Write-Host "Sync done." -ForegroundColor Green
