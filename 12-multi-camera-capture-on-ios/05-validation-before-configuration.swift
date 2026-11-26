// Swift in Practice — Edition #12: Multi-Camera Capture on iOS: The Architecture No One Tells You About
// Section: Validation Before Configuration
// https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#validation-before-configuration

func validateDeviceCombination(
    _ devices: [AVCaptureDevice]
) -> Bool {
    guard devices.count >= 2,
          Set(devices).count == devices.count else { return false }

    // This is a device-set preflight. Configuration still checks each input
    // and explicit connection against the session, then measures its cost.
    let discovery = AVCaptureDevice.DiscoverySession(
        deviceTypes: Array(Set(devices.map(\.deviceType))),
        mediaType: .video,
        position: .unspecified
    )
    return discovery.supportedMultiCamDeviceSets.contains { Set(devices).isSubset(of: $0) }
}
