// Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
// Section: Performance Optimization Tips
// https://swiftinpractice.pages.dev/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#performance-optimization-tips

// Improve startup time
player.automaticallyWaitsToMinimizeStalling = false
player.currentItem?.preferredForwardBufferDuration = 30 // seconds
