// Swift in Practice — Edition #12: Multi-Camera Capture on iOS: The Architecture No One Tells You About
// Section: The Setup (GCD-Based for Performance)
// https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#the-setup-gcd-based-for-performance

final class MultiCameraManager: NSObject {

    // MARK: - Session and Devices

    private let captureSession = AVCaptureMultiCamSession()

    // CRITICAL: Separate queue per camera output
    // Shared queue = dropped frames at 60 callbacks/sec (30 FPS × 2 cameras)
    private let backCameraQueue = DispatchQueue(
        label: "com.yourapp.camera.back",
        qos: .userInitiated
    )

    private let frontCameraQueue = DispatchQueue(
        label: "com.yourapp.camera.front",
        qos: .userInitiated
    )

    // Shared texture cache (memory efficiency)
    // Same pattern from Edition #11, now serving BOTH cameras
    private var textureCache: CVMetalTextureCache!
    private let metalDevice = MTLCreateSystemDefaultDevice()!

    private var backCameraOutput: AVCaptureVideoDataOutput?
    private var frontCameraOutput: AVCaptureVideoDataOutput?

    // MARK: - Configuration

    func configure() throws {
        // Create shared Metal texture cache
        // (Edition #11 pattern, now critical for dual cameras)
        var cache: CVMetalTextureCache?
        let result = CVMetalTextureCacheCreate(
            kCFAllocatorDefault,
            nil,
            metalDevice,
            nil,
            &cache
        )

        guard result == kCVReturnSuccess, let cache else {
            throw CameraError.metalSetupFailed
        }
        self.textureCache = cache

        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        // Configure back camera
        guard let backCamera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
        ) else {
            throw CameraError.deviceNotFound
        }

        try addCamera(
            backCamera,
            to: captureSession,
            output: &backCameraOutput,
            queue: backCameraQueue
        )

        // Configure front camera
        guard let frontCamera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front
        ) else {
            throw CameraError.deviceNotFound
        }

        try addCamera(
            frontCamera,
            to: captureSession,
            output: &frontCameraOutput,
            queue: frontCameraQueue
        )

        logger.info("Multi-camera session configured successfully")
    }

    private func addCamera(
        _ device: AVCaptureDevice,
        to session: AVCaptureMultiCamSession,
        output: inout AVCaptureVideoDataOutput?,
        queue: DispatchQueue
    ) throws {
        let input = try AVCaptureDeviceInput(device: device)

        guard session.canAddInput(input) else {
            throw CameraError.cannotAddInput
        }
        session.addInput(input)

        let videoOutput = AVCaptureVideoDataOutput()

        // CRITICAL: Use YUV 420f (native camera format)
        // BGRA conversion costs ~2-3ms per frame + thermal overhead
        // This is the same format from Edition #11
        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String:
                kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        ]

        // Real-time processing: drop late frames to prevent latency buildup
        // Recording: set false and handle buffering in delegate
        videoOutput.alwaysDiscardsLateVideoFrames = true

        guard session.canAddOutput(videoOutput) else {
            throw CameraError.cannotAddOutput
        }
        session.addOutput(videoOutput)

        videoOutput.setSampleBufferDelegate(self, queue: queue)

        // Configure connection for hardware sync
        if let connection = videoOutput.connection(with: .video) {
            // Disable automatic mirroring (we control this)
            if connection.isVideoMirroringSupported {
                connection.automaticallyAdjustsVideoMirroring = false
            }

            // Set orientation
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = .portrait
            }
        }

        output = videoOutput
    }
}
