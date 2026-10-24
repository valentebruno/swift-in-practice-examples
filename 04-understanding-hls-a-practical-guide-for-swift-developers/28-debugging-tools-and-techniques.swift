// Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
// Section: Debugging Tools and Techniques
// https://swiftinpractice.com/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#debugging-tools-and-techniques

// Access log shows quality switches, stalls, and performance
if let accessLog = player.currentItem?.accessLog() {
    accessLog.events.forEach { event in
        print("Bitrate: \(event.indicatedBitrate)")
        print("Stalls: \(event.numberOfStalls)")
        print("Segments: \(event.numberOfMediaRequests)")
        print("Dropped frames: \(event.numberOfDroppedVideoFrames)")
    }
}
