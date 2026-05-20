# Android SDK Setup Script for Flutter APK Building
$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Green
Write-Host "Android SDK Setup for Flutter" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

$AndroidHome = "C:\Android"
$SdkRoot = "$AndroidHome\sdk"
$cmdlineToolsDir = "$AndroidHome\cmdline-tools"
$toolsDir = "$cmdlineToolsDir\tools"

# Create directories
if (-not (Test-Path $AndroidHome)) {
    New-Item -ItemType Directory -Path $AndroidHome -Force | Out-Null
}

if (-not (Test-Path $SdkRoot)) {
    New-Item -ItemType Directory -Path $SdkRoot -Force | Out-Null
}

# Set environment variables
[Environment]::SetEnvironmentVariable("ANDROID_HOME", $SdkRoot, "User")
[Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $SdkRoot, "User")

Write-Host "`n✓ Environment variables set to: $SdkRoot" -ForegroundColor Green
Write-Host "Please restart your terminal and run: flutter doctor" -ForegroundColor Green
