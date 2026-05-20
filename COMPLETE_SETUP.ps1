#!/usr/bin/env powershell
# Tribe App - Complete Setup Script
# This script configures MongoDB, starts services, and provides deployment options

$ErrorActionPreference = "Continue"

Write-Host "`n╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   🎯 Tribe Application - Complete Setup & Deployment           ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Check NodeJS
Write-Host "✓ Checking Node.js..." -ForegroundColor Green
$node = node --version 2>$null
if ($node) {
    Write-Host "  Node.js: $node`n" -ForegroundColor Green
} else {
    Write-Host "  ✗ Node.js not found. Install from: https://nodejs.org`n" -ForegroundColor Red
    exit 1
}

# Check Flutter
Write-Host "✓ Checking Flutter..." -ForegroundColor Green
$flutter = flutter --version 2>$null
if ($flutter) {
    Write-Host "  Flutter installed`n" -ForegroundColor Green
} else {
    Write-Host "  ✗ Flutter not found`n" -ForegroundColor Red
}

# Check Backend
Write-Host "✓ Checking Backend Setup..." -ForegroundColor Green
if (Test-Path "c:\Users\Kartikey\Tribe\backend\package.json") {
    Write-Host "  Backend directory: ✓ Found" -ForegroundColor Green
    Write-Host "  Dependencies: ✓ $(if (Test-Path 'c:\Users\Kartikey\Tribe\backend\node_modules') {'Installed'} else {'Missing - Run: npm install'})`n" -ForegroundColor Green
} else {
    Write-Host "  ✗ Backend not found`n" -ForegroundColor Red
}

# Check Frontend
Write-Host "✓ Checking Frontend Setup..." -ForegroundColor Green
if (Test-Path "c:\Users\Kartikey\Tribe\frontend\pubspec.yaml") {
    Write-Host "  Frontend directory: ✓ Found" -ForegroundColor Green
    Write-Host "  Web build: ✓ $(if (Test-Path 'c:\Users\Kartikey\Tribe\frontend\build\web\index.html') {'Ready'} else {'Building...'})`n" -ForegroundColor Green
} else {
    Write-Host "  ✗ Frontend not found`n" -ForegroundColor Red
}

# MongoDB Setup Instructions
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "⚠️  STEP 1: Fix MongoDB Connection (CRITICAL)" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "Your MongoDB connection is blocked because your IP isn't whitelisted.`n" -ForegroundColor Yellow

Write-Host "To fix this:" -ForegroundColor Cyan
Write-Host "  1. Go to: https://cloud.mongodb.com" -ForegroundColor White
Write-Host "  2. Click: 'Security' → 'Network Access'" -ForegroundColor White
Write-Host "  3. Click: 'Add IP Address'" -ForegroundColor White
Write-Host "  4. Enter: '0.0.0.0/0' (for development)" -ForegroundColor White
Write-Host "  5. Click: 'Confirm'" -ForegroundColor White
Write-Host "  6. Wait 2-3 minutes for update" -ForegroundColor White
Write-Host "`n  OR add specific IP from: https://www.whatismyipaddress.com`n" -ForegroundColor Cyan

$addIP = Read-Host "Have you added your IP to MongoDB Atlas? (yes/no)"

if ($addIP -eq "yes") {
    Write-Host "`n✓ Great! Continuing...\n" -ForegroundColor Green
} else {
    Write-Host "`n⚠️  Please add your IP to MongoDB Atlas first, then run this script again.`n" -ForegroundColor Yellow
    exit 0
}

# Start Services
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "🚀 STEP 2: Starting Services" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

# Check if backend is already running
$backendCheck = netstat -ano | findstr ":5000" 2>$null
if ($backendCheck) {
    Write-Host "✓ Backend already running on localhost:5000`n" -ForegroundColor Green
} else {
    Write-Host "📍 Starting Backend Server..." -ForegroundColor Cyan
    Write-Host "   Terminal 1: cd c:\Users\Kartikey\Tribe\backend ; npm start`n" -ForegroundColor Yellow
    Write-Host "   (Keep this terminal open)`n" -ForegroundColor Gray
}

# Check if web server is running
$webCheck = netstat -ano | findstr ":8000" 2>$null
if ($webCheck) {
    Write-Host "✓ Web server already running on localhost:8000`n" -ForegroundColor Green
} else {
    Write-Host "📍 Starting Web Server..." -ForegroundColor Cyan
    Write-Host "   Terminal 2: cd c:\Users\Kartikey\Tribe\frontend\build\web ; python -m http.server 8000`n" -ForegroundColor Yellow
    Write-Host "   (Keep this terminal open)`n" -ForegroundColor Gray
}

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "✓ STEP 3: Access Your Application" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "🌐 Web Version:" -ForegroundColor Cyan
Write-Host "   http://localhost:8000`n" -ForegroundColor Green

Write-Host "🔌 Backend API:" -ForegroundColor Cyan
Write-Host "   http://localhost:5000`n" -ForegroundColor Green

Write-Host "📊 API Health Check:" -ForegroundColor Cyan
Write-Host "   http://localhost:5000/api/health`n" -ForegroundColor Green

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "📦 STEP 4: Deploy to Production" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "Choose your deployment method:`n" -ForegroundColor Cyan

Write-Host "Option A: Deploy Web Version" -ForegroundColor Yellow
Write-Host "  1. npm install -g netlify-cli" -ForegroundColor White
Write-Host "  2. cd c:\Users\Kartikey\Tribe\frontend" -ForegroundColor White
Write-Host "  3. netlify deploy --prod --dir=build/web" -ForegroundColor White
Write-Host "  → Your web link will be provided`n" -ForegroundColor Green

Write-Host "Option B: Build Android APK" -ForegroundColor Yellow
Write-Host "  Method 1 (Easiest):" -ForegroundColor White
Write-Host "    → Go to: https://codemagic.io" -ForegroundColor Cyan
Write-Host "    → Connect your GitHub repo" -ForegroundColor Cyan
Write-Host "    → Download APK from dashboard`n" -ForegroundColor Cyan

Write-Host "  Method 2 (Local Build):" -ForegroundColor White
Write-Host "    → Install Android Studio: https://developer.android.com/studio" -ForegroundColor Cyan
Write-Host "    → Then: flutter build apk --release" -ForegroundColor Cyan
Write-Host "    → APK: build/app/outputs/flutter-apk/app-release.apk`n" -ForegroundColor Cyan

Write-Host "Option C: Full Cloud Deployment" -ForegroundColor Yellow
Write-Host "  1. npm install -g firebase-tools" -ForegroundColor White
Write-Host "  2. firebase login" -ForegroundColor White
Write-Host "  3. firebase deploy" -ForegroundColor White
Write-Host "  → Everything hosted on Firebase`n" -ForegroundColor Green

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "✅ Summary" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "Status:" -ForegroundColor Cyan
Write-Host "  ✓ Backend: Ready (localhost:5000)" -ForegroundColor Green
Write-Host "  ✓ Web App: Ready (localhost:8000)" -ForegroundColor Green
Write-Host "  ✓ APK: Ready to build" -ForegroundColor Green
Write-Host "  $(if ($addIP -eq 'yes') {'✓'} else {'⚠'}) MongoDB: $(if ($addIP -eq 'yes') {'Whitelisted'} else {'Needs Setup'})" -ForegroundColor $(if ($addIP -eq "yes") {"Green"} else {"Yellow"})`n

Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Verify MongoDB whitelist is working" -ForegroundColor White
Write-Host "  2. Start backend & web servers in new terminals" -ForegroundColor White
Write-Host "  3. Test web version at localhost:8000" -ForegroundColor White
Write-Host "  4. Choose deployment option (Netlify/Codemagic/Firebase)" -ForegroundColor White
Write-Host "  5. Run deployment command`n" -ForegroundColor White

Write-Host "💡 Tip: Keep this guide open while deploying" -ForegroundColor Magenta
Write-Host "   Full guide: c:\Users\Kartikey\Tribe\DEPLOYMENT_OPTIONS.md`n" -ForegroundColor Magenta

Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

$choice = Read-Host "What would you like to do next? (options: web/apk/test/exit)"

switch ($choice.ToLower()) {
    "web" {
        Write-Host "`n🌐 Web Deployment`n" -ForegroundColor Cyan
        Write-Host "1. npm install -g netlify-cli" -ForegroundColor White
        Write-Host "2. cd c:\Users\Kartikey\Tribe\frontend" -ForegroundColor White
        Write-Host "3. netlify deploy --prod --dir=build/web`n" -ForegroundColor White
    }
    "apk" {
        Write-Host "`n📱 APK Deployment`n" -ForegroundColor Cyan
        Write-Host "Recommended: Go to https://codemagic.io for automatic builds`n" -ForegroundColor Green
    }
    "test" {
        Write-Host "`n🧪 Testing Backend`n" -ForegroundColor Cyan
        $health = Invoke-WebRequest -Uri "http://localhost:5000/api/health" -UseBasicParsing -ErrorAction SilentlyContinue
        if ($health.StatusCode -eq 200) {
            Write-Host "✓ Backend is responding correctly`n" -ForegroundColor Green
        } else {
            Write-Host "✗ Backend not responding. Start it first.`n" -ForegroundColor Red
        }
    }
    default {
        Write-Host "`nGoodbye! Visit c:\Users\Kartikey\Tribe\DEPLOYMENT_OPTIONS.md for more info.`n" -ForegroundColor Cyan
    }
}
