# Swift in Practice — Edition #34: Swift 6.4.2: What Compiler Fixes Reveal About Production Reliability
# Section: Record the complete build identity
# https://swiftinpractice.com/editions/34-swift-6-4-2-production-reliability/#record-the-complete-build-identity

{
  xcodebuild -version
  xcrun swiftc --version
  xcrun --sdk iphoneos --show-sdk-version
  git rev-parse HEAD
  shasum -a 256 Package.resolved
} > build-identity.txt
