// Swift in Practice — Edition #11: Building Real-Time Computer Vision Pipelines in Swift
// Section: 4️⃣ CVPixelBuffer: Memory, Not an Image
// https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#4-cvpixelbuffer-memory-not-an-image

CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
defer {
    CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
}
