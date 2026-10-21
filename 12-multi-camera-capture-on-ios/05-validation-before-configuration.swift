// Swift in Practice — Edition #12: Multi-Camera Capture on iOS: The Architecture No One Tells You About
// Section: Validation Before Configuration
// https://swiftinpractice.pages.dev/editions/12-multi-camera-capture-on-ios/#validation-before-configuration

func validateDeviceCombination(
    _ devices: [AVCaptureDevice],
    session: AVCaptureMultiCamSession
) -> Bool {
    let inputs = devices.compactMap {
        try? AVCaptureDeviceInput(device: $0)
    }

    // Test each input individually
    for input in inputs {
        guard session.canAddInput(input) else {
            logger.error("Cannot add input: \(input.device.localizedName)")
            return false
        }
    }

    return true
}
