// Swift in Practice — Edition #11: Building Real-Time Computer Vision Pipelines in Swift
// Section: Here’s the setup that works reliably:
// https://swiftinpractice.com/editions/11-building-real-time-computer-vision-pipelines-in-swift/#here-s-the-setup-that-works-reliably

func captureOutput(_ output: AVCaptureOutput,
                    didOutput sampleBuffer: CMSampleBuffer,
                    from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
        return
    }

    processingQueue.async { [weak self] in
        guard let self = self else { return }
        let result = self.process(pixelBuffer)

        DispatchQueue.main.async { [weak self] in
            self?.displayResults(result)
        }
    }
}
