# Swift in Practice — Edition #5: Swift Comes to Android — A New Era for Cross-Platform Development
# Section: Why this matters
# https://swiftinpractice.com/editions/5-swift-comes-to-android/#why-this-matters

# Install a stable toolchain with Swiftly.
# Set these variables from Swift.org's Android SDK setup guide.
: "${SWIFT_RELEASE:?Swift release version}"
: "${SWIFT_ANDROID_SDK_URL:?matching Android SDK bundle URL}"
: "${SWIFT_ANDROID_SDK_CHECKSUM:?SDK checksum from Swift.org}"
swiftly install "$SWIFT_RELEASE"
swiftly use "$SWIFT_RELEASE"
swift sdk install "$SWIFT_ANDROID_SDK_URL" --checksum "$SWIFT_ANDROID_SDK_CHECKSUM"
swift sdk list

# Create your package
swift package init --type executable

# Cross-compile for Android
swift build --swift-sdk aarch64-unknown-linux-android28

# Push to device and run
adb push .build/aarch64-unknown-linux-android28/debug/YourApp /data/local/tmp/
adb shell /data/local/tmp/YourApp
