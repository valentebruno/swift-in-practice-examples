// Swift in Practice — Edition #12: Multi-Camera Capture on iOS: The Architecture No One Tells You About
// Section: One Last Thing: The Buffer Pool Pattern
// https://swiftinpractice.pages.dev/editions/12-multi-camera-capture-on-ios/#one-last-thing-the-buffer-pool-pattern

// ❌ WRONG — creates new buffers, fragments memory
let newBuffer = CVPixelBuffer.create(...)

// ✅ RIGHT — reuse camera's IOSurface-backed buffers
// Just process the buffer you receive in the delegate
