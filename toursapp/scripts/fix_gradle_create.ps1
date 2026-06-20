param(
    [string]$ProjectRoot = "D:\Thanh\Projects\ToursApp\toursapp"
)

Set-Location $ProjectRoot

Write-Host "Running: flutter create . --platforms android --org com.example" -ForegroundColor Cyan
flutter create . --platforms android --org com.example

if ($LASTEXITCODE -eq 0) {
    Write-Host "android/ created." -ForegroundColor Green
    Write-Host "Now run: flutter build apk --debug" -ForegroundColor Green
} else {
    Write-Host "flutter create failed." -ForegroundColor Red
    exit 1
}
