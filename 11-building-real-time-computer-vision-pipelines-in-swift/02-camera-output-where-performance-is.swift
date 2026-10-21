// Swift in Practice — Edition #11: Building Real-Time Computer Vision Pipelines in Swift
// Section: 2️⃣ Camera Output: Where Performance Is Decided
// https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#2-camera-output-where-performance-is-decided

let output = AVCaptureVideoDataOutput()
output.videoSettings = [
    kCVPixelBufferPixelFormatTypeKey as String:
        kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
]

output.alwaysDiscardsLateVideoFrames = true
output.setSampleBufferDelegate(self, queue: captureQueue)
