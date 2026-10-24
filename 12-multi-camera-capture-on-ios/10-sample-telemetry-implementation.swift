// Swift in Practice — Edition #12: Multi-Camera Capture on iOS: The Architecture No One Tells You About
// Section: Sample Telemetry Implementation
// https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#sample-telemetry-implementation

struct CameraMetrics {
    var sessionStartTime: Date
    var framesProcessed: Int = 0
    var framesDropped: Int = 0
    var thermalStateChanges: [(ProcessInfo.ThermalState, Date)] = []
    var memoryWarnings: Int = 0
    var interruptionCount: Int = 0
    var maxFrameDrift: TimeInterval = 0

    func report() -> [String: Any] {
        let duration = Date().timeIntervalSince(sessionStartTime)
        let dropRate = Double(framesDropped) / Double(max(framesProcessed, 1))

        return [
            "session_duration_seconds": duration,
            "frames_processed": framesProcessed,
            "drop_rate_percent": dropRate * 100,
            "thermal_changes": thermalStateChanges.count,
            "memory_warnings": memoryWarnings,
            "max_frame_drift_ms": maxFrameDrift * 1000,
            "interruptions": interruptionCount
        ]
    }
}
