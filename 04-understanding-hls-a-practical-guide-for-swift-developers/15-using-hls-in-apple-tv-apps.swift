// Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
// Section: Using HLS in Apple TV Apps
// https://swiftinpractice.com/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#using-hls-in-apple-tv-apps

import AVKit
import SwiftUI

// Keep the player in @State: a SwiftUI view struct is re-created whenever its
// parent updates, so a plain `let player` would build a new AVPlayer each time.
struct VideoPlayerView: View {
    @State private var player: AVPlayer

    init(url: URL) {
        _player = State(initialValue: AVPlayer(url: url))
    }

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()
            }
    }
}
