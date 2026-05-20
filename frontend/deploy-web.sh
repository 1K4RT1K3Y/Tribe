#!/bin/bash
# Tribe Web Deployment Script

echo "🚀 Deploying Tribe Web Application..."

# Check if build exists
if [ ! -d "build/web" ]; then
    echo "❌ Web build not found. Run 'flutter build web --release' first."
    exit 1
fi

echo "✅ Web build found at build/web/"

# Create deployment package
echo "📦 Creating deployment package..."
cd build/web
tar -czf ../../tribe-web-deployment.tar.gz .

echo "📋 Deployment Instructions:"
echo "1. Upload 'tribe-web-deployment.tar.gz' to your hosting provider"
echo "2. Extract the contents to your web root directory"
echo ""
echo "Recommended Hosting Options:"
echo "- Vercel: Drag & drop the build/web folder"
echo "- Netlify: Drag & drop the build/web folder"
echo "- Firebase: firebase deploy (after firebase init)"
echo "- GitHub Pages: Use flutter build web --release --base-href=/repo-name/"
echo ""
echo "🌐 Your web app will be accessible at: https://your-domain.com"
echo "📱 APK will be available at: C:\Users\Kartikey\Tribe\frontend\build\app\outputs\flutter-apk\app-release.apk"