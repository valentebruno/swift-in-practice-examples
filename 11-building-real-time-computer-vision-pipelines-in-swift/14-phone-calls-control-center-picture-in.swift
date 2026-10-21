// Swift in Practice — Edition #11: Building Real-Time Computer Vision Pipelines in Swift
// Section: Phone calls. Control Center. Picture-in-Picture. FaceTime. Notification Center. Screen recording.
// https://swiftinpractice.pages.dev/editions/11-building-real-time-computer-vision-pipelines-in-swift/#phone-calls-control-center-picture-in-picture-facetime-notif

private let gpuSemaphore = DispatchSemaphore(value: 3)  // Max 3 in-flight frames

func submitFrame() {
    guard let commandBuffer = commandQueue.makeCommandBuffer() else {
        return
    }

    gpuSemaphore.wait()

    commandBuffer.addCompletedHandler { [weak self] _ in
        self?.gpuSemaphore.signal()
    }

    guard let encoder = commandBuffer.makeComputeCommandEncoder() else {
        gpuSemaphore.signal()
        return
    }

    // ... encode operations ...
    encoder.endEncoding()
    commandBuffer.commit()
}
