#!/bin/bash

# Script to initialize a new Flutter app from base project
# Usage: ./scripts/init_app.sh <app_name> <package_name> <bundle_id>
# Example: ./scripts/init_app.sh "My App" "com.example.myapp" "com.example.myapp"

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if all arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    print_error "Usage: $0 <app_name> <package_name> [bundle_id]"
    print_info "Example: $0 \"My App\" \"com.example.myapp\" \"com.example.myapp\""
    exit 1
fi

APP_NAME="$1"
PACKAGE_NAME="$2"
BUNDLE_ID="${3:-$PACKAGE_NAME}"

# Convert app name to lowercase with underscores for project name
PROJECT_NAME=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | sed 's/[^a-z0-9_]//g')

# Get current directory name (old project name)
OLD_PROJECT_NAME="kullhi_flutter_base"
OLD_PACKAGE_NAME="com.example.kullhi_flutter_base"

print_info "Initializing new Flutter app..."
print_info "App Name: $APP_NAME"
print_info "Project Name: $PROJECT_NAME"
print_info "Package Name: $PACKAGE_NAME"
print_info "Bundle ID: $BUNDLE_ID"
echo ""

# Step 1: Remove old git history
print_info "Removing old git history..."
if [ -d ".git" ]; then
    rm -rf .git
    print_success "Git history removed"
else
    print_warning "No git directory found"
fi

# Step 2: Update pubspec.yaml
print_info "Updating pubspec.yaml..."
if [ -f "pubspec.yaml" ]; then
    sed -i '' "s/^name: .*/name: $PROJECT_NAME/" pubspec.yaml
    sed -i '' "s/description: .*/description: \"$APP_NAME\"/" pubspec.yaml
    print_success "pubspec.yaml updated"
else
    print_error "pubspec.yaml not found!"
    exit 1
fi

# Step 3: Update Android package name
print_info "Updating Android package name..."

# Update build.gradle.kts or build.gradle
if [ -f "android/app/build.gradle.kts" ]; then
    sed -i '' "s/namespace = \".*\"/namespace = \"$PACKAGE_NAME\"/" android/app/build.gradle.kts
    sed -i '' "s/applicationId = \".*\"/applicationId = \"$PACKAGE_NAME\"/" android/app/build.gradle.kts
    print_success "build.gradle.kts updated"
elif [ -f "android/app/build.gradle" ]; then
    sed -i '' "s/namespace \".*\"/namespace \"$PACKAGE_NAME\"/" android/app/build.gradle
    sed -i '' "s/applicationId \".*\"/applicationId \"$PACKAGE_NAME\"/" android/app/build.gradle
    print_success "build.gradle updated"
fi

# Update AndroidManifest.xml files
for manifest in android/app/src/*/AndroidManifest.xml; do
    if [ -f "$manifest" ]; then
        sed -i '' "s/package=\".*\"/package=\"$PACKAGE_NAME\"/" "$manifest"
    fi
done
print_success "AndroidManifest.xml files updated"

# Create new package directory structure for Kotlin files
OLD_PACKAGE_PATH=$(echo "$OLD_PACKAGE_NAME" | tr '.' '/')
NEW_PACKAGE_PATH=$(echo "$PACKAGE_NAME" | tr '.' '/')

for variant in main debug profile; do
    OLD_DIR="android/app/src/$variant/kotlin/$OLD_PACKAGE_PATH"
    NEW_DIR="android/app/src/$variant/kotlin/$NEW_PACKAGE_PATH"
    
    if [ -d "$OLD_DIR" ]; then
        mkdir -p "$NEW_DIR"
        if [ -f "$OLD_DIR/MainActivity.kt" ]; then
            # Update package name in the file and move
            sed "s/package .*/package $PACKAGE_NAME/" "$OLD_DIR/MainActivity.kt" > "$NEW_DIR/MainActivity.kt"
            rm -rf "android/app/src/$variant/kotlin/$(echo $OLD_PACKAGE_NAME | cut -d. -f1)"
        fi
        print_success "Kotlin files updated for $variant"
    fi
done

# Step 4: Update iOS bundle identifier
print_info "Updating iOS bundle identifier..."

# Update project.pbxproj
if [ -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
    sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = .*;/PRODUCT_BUNDLE_IDENTIFIER = $BUNDLE_ID;/g" ios/Runner.xcodeproj/project.pbxproj
    print_success "iOS project.pbxproj updated"
fi

# Step 5: Update app name in Android
print_info "Updating Android app name..."
if [ -f "android/app/src/main/AndroidManifest.xml" ]; then
    sed -i '' "s/android:label=\".*\"/android:label=\"$APP_NAME\"/" android/app/src/main/AndroidManifest.xml
    print_success "Android app name updated"
fi

# Step 6: Update app name in iOS
print_info "Updating iOS app name..."
if [ -f "ios/Runner/Info.plist" ]; then
    # Use perl for multi-line replacement in plist
    perl -i -0777 -pe "s/<key>CFBundleDisplayName<\/key>\s*<string>.*?<\/string>/<key>CFBundleDisplayName<\/key>\n\t<string>$APP_NAME<\/string>/s" ios/Runner/Info.plist
    perl -i -0777 -pe "s/<key>CFBundleName<\/key>\s*<string>.*?<\/string>/<key>CFBundleName<\/key>\n\t<string>$APP_NAME<\/string>/s" ios/Runner/Info.plist
    print_success "iOS app name updated"
fi

# Step 7: Update Dart imports
print_info "Updating Dart imports..."
find lib -name "*.dart" -type f -exec sed -i '' "s/package:$OLD_PROJECT_NAME/package:$PROJECT_NAME/g" {} \;
find test -name "*.dart" -type f -exec sed -i '' "s/package:$OLD_PROJECT_NAME/package:$PROJECT_NAME/g" {} \; 2>/dev/null || true
print_success "Dart imports updated"

# Step 8: Update app constants
print_info "Updating app constants..."
if [ -f "lib/app/core/constants/app_constants.dart" ]; then
    sed -i '' "s/static const String appName = '.*';/static const String appName = '$APP_NAME';/" lib/app/core/constants/app_constants.dart
    print_success "App constants updated"
fi

# Step 9: Update app.dart title
print_info "Updating app title..."
if [ -f "lib/app/app.dart" ]; then
    sed -i '' "s/title: '.*',/title: '$APP_NAME',/" lib/app/app.dart
    print_success "App title updated"
fi

# Step 10: Update README
print_info "Updating README..."
if [ -f "README.md" ]; then
    sed -i '' "1s/.*/# $APP_NAME/" README.md
    print_success "README updated"
fi

# Step 11: Clean and get dependencies
print_info "Cleaning and getting dependencies..."
flutter clean > /dev/null 2>&1
flutter pub get > /dev/null 2>&1
print_success "Dependencies updated"

# Step 12: Regenerate code
print_info "Regenerating code..."
dart run build_runner build --delete-conflicting-outputs > /dev/null 2>&1 || print_warning "Build runner had some issues, please run manually"
print_success "Code regenerated"

# Step 13: Initialize new git repository
print_info "Initializing new git repository..."
git init > /dev/null 2>&1
git add . > /dev/null 2>&1
git commit -m "Initial commit: $APP_NAME" > /dev/null 2>&1
print_success "Git repository initialized"

echo ""
print_success "=========================================="
print_success "App initialization complete!"
print_success "=========================================="
echo ""
print_info "App Name: $APP_NAME"
print_info "Project Name: $PROJECT_NAME"
print_info "Package Name: $PACKAGE_NAME"
print_info "Bundle ID: $BUNDLE_ID"
echo ""
print_info "Next steps:"
echo "  1. Run 'flutter run' to test the app"
echo "  2. Update assets and translations as needed"
echo "  3. Start building your app!"
echo ""
