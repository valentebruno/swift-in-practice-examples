// Swift in Practice — Edition #12: Multi-Camera Capture on iOS: The Architecture No One Tells You About
// Section: The Solution: Trust Nothing
// https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#the-solution-trust-nothing

extension MultiCameraManager {

    func setupLifecycleMonitoring() {
        // KVO is more reliable than notifications for session state
        captureSession.observe(\.isRunning, options: [.new]) { [weak self] session, change in
            if let isRunning = change.newValue {
                if isRunning {
                    self?.handleSessionResumed()
                } else {
                    self?.handleSessionStopped()
                }
            }
        }

        // Monitor interruptions
        NotificationCenter.default.addObserver(
            forName: .AVCaptureSessionWasInterrupted,
            object: captureSession,
            queue: .main
        ) { [weak self] notification in
            if let reason = notification.userInfo?[AVCaptureSessionInterruptionReasonKey]
                as? AVCaptureSession.InterruptionReason {
                self?.handleInterruption(reason)
            }
        }

        NotificationCenter.default.addObserver(
            forName: .AVCaptureSessionInterruptionEnded,
            object: captureSession,
            queue: .main
        ) { [weak self] _ in
            self?.verifyBothCamerasAfterResume()
        }
    }

    private func handleInterruption(_ reason: AVCaptureSession.InterruptionReason) {
        switch reason {
        case .videoDeviceNotAvailableInBackground:
            logger.info("App backgrounded")

        case .videoDeviceInUseByAnotherClient:
            logger.warning("Camera taken by another app")

        case .videoDeviceNotAvailableWithMultipleForegroundApps:
            logger.warning("Split-screen/PiP active")

        @unknown default:
            logger.warning("Unknown interruption")
        }
    }

    // CRITICAL: This is the pattern that fixed our 67% → 98% resume success rate
    private func verifyBothCamerasAfterResume() {
        // Check both cameras individually
        // One may resume while the other stays interrupted

        var backActive = false
        var frontActive = false

        if let backConn = backCameraOutput?.connection(with: .video),
           backConn.isActive {
            backActive = true
        }

        if let frontConn = frontCameraOutput?.connection(with: .video),
           frontConn.isActive {
            frontActive = true
        }

        if !backActive || !frontActive {
            logger.error("""
                Camera state mismatch after resume:
                Back: \(backActive), Front: \(frontActive)
                Attempting recovery...
                """)

            // Attempt recovery
            if !captureSession.isRunning {
                captureSession.startRunning()
            }

            // Verify after short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self else { return }

                if !self.captureSession.isRunning {
                    logger.error("Session failed to resume — falling back to single camera")
                    self.fallbackToSingleCamera()
                }
            }
        } else {
            logger.info("Both cameras resumed successfully")
        }
    }

    private func fallbackToSingleCamera() {
        // Graceful degradation to single-camera mode
        // (Implementation depends on app requirements)
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        frontCameraOutput?.setSampleBufferDelegate(nil, queue: nil)
        logger.info("Running in single-camera fallback mode")
    }
}
