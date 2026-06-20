param(
    [string]$ProjectRoot = "D:\Thanh\Projects\ToursApp\toursapp"
)

$android = "$ProjectRoot\android"
Set-Location $ProjectRoot

if (Test-Path $android) {
    Write-Host "android/ exists -> patching Gradle files..." -ForegroundColor Cyan
    & "$PSScriptRoot\fix_gradle_patch.ps1" -ProjectRoot $ProjectRoot
} else {
    Write-Host "android/ missing -> generating with flutter create..." -ForegroundColor Cyan
    & "$PSScriptRoot\fix_gradle_create.ps1" -ProjectRoot $ProjectRoot
}
