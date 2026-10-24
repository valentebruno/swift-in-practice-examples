// Swift in Practice — Edition #11: Building Real-Time Computer Vision Pipelines in Swift
// Section: 3️⃣ CMSampleBuffer vs CVPixelBuffer: Know What You’re Touching
// https://swiftinpractice.com/editions/11-building-real-time-computer-vision-pipelines-in-swift/#3-cmsamplebuffer-vs-cvpixelbuffer-know-what-you-re-touching

func captureOutput(_ output: AVCaptureOutput,
                    didOutput sampleBuffer: CMSampleBuffer,
                    from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
        return
    }
    process(pixelBuffer)
}
