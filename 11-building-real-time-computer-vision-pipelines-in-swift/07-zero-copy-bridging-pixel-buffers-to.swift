// Swift in Practice — Edition #11: Building Real-Time Computer Vision Pipelines in Swift
// Section: 5️⃣ Zero-Copy: Bridging Pixel Buffers to Metal
// https://swiftinpractice.com/editions/11-building-real-time-computer-vision-pipelines-in-swift/#5-zero-copy-bridging-pixel-buffers-to-metal

// DON'T DO THIS
let bytes = CVPixelBufferGetBaseAddress(pixelBuffer)
let texture = device.makeTexture(descriptor: descriptor)
texture.replace(region: region, mipmapLevel: 0, withBytes: bytes, bytesPerRow: bytesPerRow)
