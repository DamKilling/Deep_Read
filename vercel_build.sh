#!/bin/bash
# Vercel deployment script for Flutter Web

echo "Downloading Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1

echo "Adding Flutter to PATH..."
export PATH="$PATH:`pwd`/flutter/bin"

echo "Running Flutter pub get..."
flutter pub get

echo "Building Flutter Web..."
# Inject environment variables during the build process
flutter build web --release \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY

echo "Build complete!"
