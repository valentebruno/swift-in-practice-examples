// Swift in Practice — Edition #12: Multi-Camera Capture on iOS: The Architecture No One Tells You About
// Section: Production Pattern
// https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#production-pattern

@MainActor
final class ThermalManager {

    enum CameraMode {
        case dual           // Both cameras, full quality
        case backOnly       // Front suspended
        case reducedQuality // 720p, both cameras
        case minimal        // 480p, back only
    }

    private(set) var currentMode = CameraMode.dual

    // Don't react to transient spikes
    private var thermalHistory: [ProcessInfo.ThermalState] = []
    private let historyWindow = 5

    func handleThermalStateChange(_ state: ProcessInfo.ThermalState) -> CameraMode {
        thermalHistory.append(state)
        if thermalHistory.count > historyWindow {
            thermalHistory.removeFirst()
        }

        // Count serious/critical states in recent history
        let recentHigh = thermalHistory.filter {
            $0 == .serious || $0 == .critical
        }.count

        let newMode: CameraMode

        switch state {
        case .nominal, .fair:
            // Safe to run full quality
            newMode = .dual

        case .serious:
            // Persistent serious state → more aggressive throttling
            if recentHigh >= 3 {
                newMode = .backOnly
            } else {
                newMode = .reducedQuality
            }

        case .critical:
            // Emergency fallback
            newMode = .minimal

        @unknown default:
            newMode = .reducedQuality
        }

        if newMode != currentMode {
            currentMode = newMode
            logger.info("Thermal \(state) → mode \(newMode)")
        }

        return newMode
    }
}

// MARK: - Integration with Session

extension MultiCameraManager {

    func setupThermalMonitoring() {
        NotificationCenter.default.addObserver(
            forName: ProcessInfo.thermalStateDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            let newMode = self.thermalManager.handleThermalStateChange(
                ProcessInfo.processInfo.thermalState
            )
            self.adjustCameraMode(newMode)
        }
    }

    private func adjustCameraMode(_ mode: ThermalManager.CameraMode) {
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        switch mode {
        case .dual:
            // Full quality, both cameras
            if let front = frontCameraOutput {
                front.setSampleBufferDelegate(self, queue: frontCameraQueue)
            }
            captureSession.sessionPreset = .hd1920x1080

        case .backOnly:
            // Suspend front camera
            frontCameraOutput?.setSampleBufferDelegate(nil, queue: nil)
            captureSession.sessionPreset = .hd1920x1080

        case .reducedQuality:
            // 720p, both cameras
            if let front = frontCameraOutput {
                front.setSampleBufferDelegate(self, queue: frontCameraQueue)
            }
            captureSession.sessionPreset = .hd1280x720

        case .minimal:
            // Emergency: 480p, back only
            frontCameraOutput?.setSampleBufferDelegate(nil, queue: nil)
            captureSession.sessionPreset = .vga640x480
        }
    }
}
