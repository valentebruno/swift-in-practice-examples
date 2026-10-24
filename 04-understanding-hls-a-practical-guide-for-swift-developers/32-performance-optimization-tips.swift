// Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
// Section: Performance Optimization Tips
// https://swiftinpractice.com/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#performance-optimization-tips

func prefetchNextVideo(url: URL) async {
    let asset = AVURLAsset(url: url)

    // Load the playlist and its tracks without creating a player.
    // (loadValuesAsynchronously is deprecated since iOS 16.)
    _ = try? await asset.load(.tracks, .duration)
    print("Next video prefetched")
}
