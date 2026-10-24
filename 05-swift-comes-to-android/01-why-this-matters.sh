# Swift in Practice — Edition #5: Swift Comes to Android — A New Era for Cross-Platform Development
# Section: Why this matters
# https://swiftinpractice.com/editions/5-swift-comes-to-android/#why-this-matters

# Install the toolchain manager
curl -L https://swift-server.github.io/swiftly/swiftly-install.sh | bash

# Install a matching Swift snapshot
swiftly install main-snapshot-2025-10-16

# Install the Android SDK bundle
swift sdk install https://download.swift.org/.../swift-android-sdk.tar.gz

# Create your package
swift package init --type executable

# Cross-compile for Android
swift build --swift-sdk aarch64-unknown-linux-android28

# Push to device and run
adb push .build/aarch64-unknown-linux-android28/debug/YourApp /data/local/tmp/
adb shell /data/local/tmp/YourApp
