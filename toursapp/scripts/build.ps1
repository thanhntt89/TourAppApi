# Sync F→D rồi build APK
param(
    [ValidateSet("debug", "release", "profile")]
    [string]$Mode = "debug",
    [string]$FlutterRoot = "D:\Thanh\Projects\ToursApp\toursapp",
    [string]$ApiUrl = "https://hagiang.caremycars.com/wp-json/toursapp/v1",
    [string]$SentryDsn = ""
)

# 1. Sync
& "$PSScriptRoot\sync.ps1"
if ($LASTEXITCODE -gt 1) { Write-Host "Sync had errors." -ForegroundColor Yellow }

# 2. Build
Write-Host "`nBuilding APK ($Mode)..." -ForegroundColor Cyan
Set-Location $FlutterRoot

$dartDefines = "--dart-define=API_BASE_URL=$ApiUrl"
if ($SentryDsn) { $dartDefines += " --dart-define=SENTRY_DSN=$SentryDsn" }

flutter build apk "--$Mode" $dartDefines

if ($LASTEXITCODE -eq 0) {
    $apkPath = "$FlutterRoot\build\app\outputs\flutter-apk\app-$Mode.apk"
    Write-Host "`nBuild OK: $apkPath" -ForegroundColor Green

    # Copy APK back to F: for easy access
    $dstDir = "F:\Jimmii\Projects\ToursApp\toursapp\build\apk"
    New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
    Copy-Item $apkPath "$dstDir\app-$Mode.apk" -Force
    Write-Host "Copied to: $dstDir\app-$Mode.apk" -ForegroundColor Green
} else {
    Write-Host "`nBuild FAILED." -ForegroundColor Red
    exit 1
}
