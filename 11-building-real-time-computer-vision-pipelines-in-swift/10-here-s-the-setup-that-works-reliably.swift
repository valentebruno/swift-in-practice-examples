// Swift in Practice — Edition #11: Building Real-Time Computer Vision Pipelines in Swift
// Section: Here’s the setup that works reliably:
// https://swiftinpractice.com/editions/11-building-real-time-computer-vision-pipelines-in-swift/#here-s-the-setup-that-works-reliably

// Capture queue: should be serial to maintain frame order
private let captureQueue = DispatchQueue(
    label: "com.yourapp.capture",
    qos: .userInteractive
)

// Processing queue: can be serial or concurrent depending on your needs
private let processingQueue = DispatchQueue(
    label: "com.yourapp.processing",
    qos: .userInitiated,
    attributes: .concurrent
)

output.setSampleBufferDelegate(self, queue: captureQueue)
