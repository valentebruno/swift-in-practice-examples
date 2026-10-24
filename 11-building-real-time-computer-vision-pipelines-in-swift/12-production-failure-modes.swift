// Swift in Practice — Edition #11: Building Real-Time Computer Vision Pipelines in Swift
// Section: 8️⃣ Production Failure Modes
// https://swiftinpractice.com/editions/11-building-real-time-computer-vision-pipelines-in-swift/#8-production-failure-modes

NotificationCenter.default.addObserver(
    forName: ProcessInfo.thermalStateDidChangeNotification,
    object: nil,
    queue: .main
) { [weak self] _ in
    self?.adjustForThermalState()
}

func adjustForThermalState() {
    switch ProcessInfo.processInfo.thermalState {
    case .nominal, .fair:
        targetFrameRate = 60
    case .serious:
        targetFrameRate = 30
    case .critical:
        targetFrameRate = 15
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .medium
        captureSession.commitConfiguration()
    @unknown default:
        break
    }
}
