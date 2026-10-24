// Swift in Practice — Edition #12: Multi-Camera Capture on iOS: The Architecture No One Tells You About
// Section: Frame Processing: The Sendable-Safe Pattern
// https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#frame-processing-the-sendable-safe-pattern

// MARK: - Frame Wrapper (Swift 6 Concurrency-Safe)

/// Wraps CVPixelBuffer for safe transfer across concurrency domains
/// @unchecked Sendable because CVPixelBuffer predates Sendable protocol
/// but is thread-safe via ARC (toll-free bridged to Swift)
struct CameraFrame: @unchecked Sendable {
    let pixelBuffer: CVPixelBuffer
    let timestamp: CMTime
    let position: AVCaptureDevice.Position

    // Note: CVPixelBuffer is ARC-managed in Swift
    // No manual CVBufferRetain/Release needed
}

// MARK: - Delegate Implementation

extension MultiCameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)

        // Determine camera position from connection
        let position: AVCaptureDevice.Position
        if let port = connection.inputPorts.first {
            position = port.sourceDevicePosition
        } else {
            logger.error("Cannot determine camera position")
            return
        }

        let frame = CameraFrame(
            pixelBuffer: pixelBuffer,
            timestamp: timestamp,
            position: position
        )

        // Track frame drift (this is how we measured the TestFlight data)
        trackFrameDrift(frame)

        // Process frame (Metal rendering, recording, etc.)
        processFrame(frame)
    }

    // MARK: - Frame Drift Tracking

    private var lastBackTimestamp: CMTime?
    private var lastFrontTimestamp: CMTime?

    private func trackFrameDrift(_ frame: CameraFrame) {
        switch frame.position {
        case .back:
            lastBackTimestamp = frame.timestamp
        case .front:
            lastFrontTimestamp = frame.timestamp
        default:
            break
        }

        // Calculate drift when we have both timestamps
        if let backTime = lastBackTimestamp,
           let frontTime = lastFrontTimestamp {
            let drift = abs(backTime.seconds - frontTime.seconds)

            if drift > 0.005 { // 5ms threshold
                logger.warning("Frame drift: \(drift * 1000)ms")
                metrics.maxFrameDrift = max(metrics.maxFrameDrift, drift)
            }
        }
    }

    // MARK: - Frame Processing

    private func processFrame(_ frame: CameraFrame) {
        // Convert YUV to Metal textures (zero-copy, same as Edition #11)
        guard let textures = createMetalTextures(from: frame.pixelBuffer) else {
            logger.error("Failed to create Metal textures")
            return
        }

        // Process with Metal shader (YUV → RGB conversion if needed)
        // Record to file, display to screen, etc.

        // CRITICAL: Flush texture cache periodically
        // (More critical with 2 cameras than single camera)
        frameCount += 1
        if frameCount % 60 == 0 {
            CVMetalTextureCacheFlush(textureCache, 0)
        }
    }

    // MARK: - Metal Texture Creation (Edition #11 pattern)

    private func createMetalTextures(
        from pixelBuffer: CVPixelBuffer
    ) -> (y: MTLTexture, uv: MTLTexture)? {

        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)

        // Y plane (luminance)
        var yTexture: CVMetalTexture?
        var result = CVMetalTextureCacheCreateTextureFromImage(
            kCFAllocatorDefault,
            textureCache,
            pixelBuffer,
            nil,
            .r8Unorm,
            width,
            height,
            0, // plane index
            &yTexture
        )

        guard result == kCVReturnSuccess,
              let yTex = yTexture,
              let yMetal = CVMetalTextureGetTexture(yTex) else {
            return nil
        }

        // UV plane (chrominance)
        var uvTexture: CVMetalTexture?
        result = CVMetalTextureCacheCreateTextureFromImage(
            kCFAllocatorDefault,
            textureCache,
            pixelBuffer,
            nil,
            .rg8Unorm,
            width / 2,
            height / 2,
            1, // plane index
            &uvTexture
        )

        guard result == kCVReturnSuccess,
              let uvTex = uvTexture,
              let uvMetal = CVMetalTextureGetTexture(uvTex) else {
            return nil
        }

        return (yMetal, uvMetal)
    }
}
