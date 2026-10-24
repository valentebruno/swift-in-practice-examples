// Swift in Practice — Edition #12: Multi-Camera Capture on iOS: The Architecture No One Tells You About
// Section: The Story: “We Need Dual Camera Support”
// https://swiftinpractice.com/editions/12-multi-camera-capture-on-ios/#the-story-we-need-dual-camera-support

let backSession = AVCaptureSession()
let frontSession = AVCaptureSession()
// Configure separately, timestamp independently
