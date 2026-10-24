// Swift in Practice — Edition #11: Building Real-Time Computer Vision Pipelines in Swift
// Section: Memory Leaks via Retain Cycles
// https://swiftinpractice.com/editions/11-building-real-time-computer-vision-pipelines-in-swift/#memory-leaks-via-retain-cycles

// WRONG - Common retain cycle
func captureOutput(_ output: AVCaptureOutput,
                  didOutput sampleBuffer: CMSampleBuffer,
                  from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

    processingQueue.async {
        // 'self' is captured strongly here if you use any properties/methods
        self.process(pixelBuffer)  // Cycle if processingQueue is owned by self
    }
}

// CORRECT - Break the cycle
func captureOutput(_ output: AVCaptureOutput,
                  didOutput sampleBuffer: CMSampleBuffer,
                  from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

    processingQueue.async { [weak self] in
        guard let self = self else { return }
        self.process(pixelBuffer)
    }
}

// Always clean up in deinit
deinit {
    captureSession.stopRunning()
    output.setSampleBufferDelegate(nil, queue: nil)
    captureSessionRunningObserver?.invalidate()
}
