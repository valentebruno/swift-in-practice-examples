// Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
// Section: Performance Optimization Tips
// https://swiftinpractice.pages.dev/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#performance-optimization-tips

func prefetchNextVideo(url: URL) {
    let asset = AVAsset(url: url)

    // Trigger playlist load without creating player
    asset.loadValuesAsynchronously(forKeys: ["tracks", "duration"]) {
        // Playlist is now cached
        print("Next video prefetched")
    }
}
