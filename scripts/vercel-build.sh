#!/bin/bash
set -e  # Exit on error

echo "🚀 Starting Flutter build on Vercel..."

# Install Flutter if not present
if ! command -v flutter &> /dev/null; then
    echo "📦 Installing Flutter SDK..."
    # Download Flutter SDK
    cd /tmp
    wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
    tar -xf flutter_linux_3.24.5-stable.tar.xz
    export PATH="/tmp/flutter/bin:$PATH"
    
    # Add to PATH for future commands
    echo 'export PATH="/tmp/flutter/bin:$PATH"' >> ~/.bashrc
else
    echo "✅ Flutter already installed"
fi

# Verify Flutter installation
echo "📋 Flutter version:"
flutter --version || true

# Accept Android licenses (non-interactive)
echo "📱 Accepting Android licenses..."
yes | flutter doctor --android-licenses || true

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean || true

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get || {
    echo "❌ flutter pub get failed"
    exit 1
}

# Build the web app
echo "🏗️ Building web app..."
flutter build web --release || {
    echo "❌ flutter build failed"
    exit 1
}

# Verify build output
if [ -d "build/web" ]; then
    echo "✅ Build successful! Files in build/web:"
    ls -la build/web/
else
    echo "❌ Build directory not found!"
    exit 1
fi

echo "🎉 Build completed successfully!"
