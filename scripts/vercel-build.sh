#!/bin/bash

# Install Flutter if not available
if ! command -v flutter &> /dev/null
then
    echo "Flutter not found, installing..."
    # Download Flutter SDK
    git clone https://github.com/flutter/flutter.git -b stable ~/flutter
    export PATH="$PATH:$HOME/flutter/bin"
fi

# Get dependencies
flutter pub get

# Build the web app
flutter build web --release

# Verify build output
ls -la build/web/
