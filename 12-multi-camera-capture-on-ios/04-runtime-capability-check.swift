// Swift in Practice — Edition #12: Multi-Camera Capture on iOS: The Architecture No One Tells You About
// Section: Runtime Capability Check
// https://swiftinpractice.pages.dev/editions/12-multi-camera-capture-on-ios/#runtime-capability-check

guard AVCaptureMultiCamSession.isMultiCamSupported else {
    logger.warning("Multi-cam not supported on this device")
    return setupSingleCameraFallback()
}
