#!/bin/bash
# Vercel build script for Flutter Web
set -e

echo "=== Starting Flutter Web Build ==="

# 1. Download Flutter SDK (stable branch)
echo "=> Downloading Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1 _flutter

# 2. Add Flutter to PATH
export PATH="$PATH:`pwd`/_flutter/bin"

# 3. Verify flutter installation
echo "=> Verifying Flutter version..."
flutter --version

# 4. Get dependencies
echo "=> Fetching dependencies..."
flutter pub get

# 5. Build for web
echo "=> Building Flutter Web..."
# Using environment variables passed from Vercel dashbaord
flutter build web --release \
  --dart-define=SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"

echo "=== Build Completed Successfully ==="
