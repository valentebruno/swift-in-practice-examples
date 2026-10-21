// Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
// Section: Performance Optimization Tips
// https://swiftinpractice.pages.dev/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#performance-optimization-tips

import AVFoundation

// In AppDelegate or App
func setupAudioSession() throws {
    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(.playback, mode: .moviePlayback)
    try audioSession.setActive(true)
}
