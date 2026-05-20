@echo off
REM Tribe Web Deployment Script - Windows PowerShell
REM This script packages and prepares the web build for deployment

echo.
echo ========================================
echo   TRIBE WEB DEPLOYMENT PACKAGE
echo ========================================
echo.

REM Check if build exists
if not exist "build\web" (
    echo ERROR: Web build not found at build\web
    echo Please run: flutter build web --release
    pause
    exit /b 1
)

echo [OK] Web build found at: build\web

REM Create zip file for deployment
echo.
echo Creating deployment package...
powershell -Command "Compress-Archive -Path 'build\web\*' -DestinationPath '..\tribe-web-deployment.zip' -Force"

if exist "..\tribe-web-deployment.zip" (
    echo [OK] Created: ..\tribe-web-deployment.zip
) else (
    echo ERROR: Failed to create deployment zip
    pause
    exit /b 1
)

echo.
echo ========================================
echo   DEPLOYMENT INSTRUCTIONS
echo ========================================
echo.
echo WEB DEPLOYMENT OPTIONS:
echo.
echo 1. VERCEL (Recommended - Fastest)
echo    - Go to: https://vercel.com
echo    - Import project from GitHub or drag build/web folder
echo    - Auto-deploys
echo.
echo 2. NETLIFY (Alternative)
echo    - Go to: https://netlify.com
echo    - Drag and drop build/web folder
echo    - Instant deployment
echo.
echo 3. GITHUB PAGES
echo    - Run: flutter build web --release --base-href=/tribe-app/
echo    - Commit to gh-pages branch
echo.
echo 4. FIREBASE HOSTING
echo    - Run: npm install -g firebase-tools
echo    - Run: firebase login
echo    - Run: firebase init hosting
echo    - Run: firebase deploy
echo.
echo ========================================
echo   FILE LOCATIONS
echo ========================================
echo.
echo Web Build:  C:\Users\Kartikey\Tribe\frontend\build\web
echo APK Build:  C:\Users\Kartikey\Tribe\frontend\build\app\outputs\flutter-apk\app-release.apk
echo Deployment: ..\tribe-web-deployment.zip
echo.
echo ========================================
echo.
pause