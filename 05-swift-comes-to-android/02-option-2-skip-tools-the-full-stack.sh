# Swift in Practice — Edition #5: Swift Comes to Android — A New Era for Cross-Platform Development
# Section: Option 2: Skip.tools (The Full-Stack Solution)
# https://swiftinpractice.com/editions/5-swift-comes-to-android/#option-2-skip-tools-the-full-stack-solution

# Install Skip
brew install skiptools/skip/skip

# Create a dual-platform app
skip init --appid=com.yourcompany.app YourApp

# Open in Xcode
open YourApp/Package.swift

# Write SwiftUI as you normally would
# Hit ⌘R to build for iOS
# Use Skip's build system for Android
