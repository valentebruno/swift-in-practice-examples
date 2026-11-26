// Swift in Practice — Edition #27: A Fold Shouldn’t Restart Playback
// Section: How a view ends up owning the audio
// https://swiftinpractice.com/editions/27-audio-continuity-across-layout-changes/#how-a-view-ends-up-owning-the-audio

import SwiftUI
import AVFoundation

struct FragilePlayerScreen: View {
    let url: URL
    @State private var player = AVPlayer()

    var body: some View {
        Button("Pause") { player.pause() }
            .onAppear {
                player.replaceCurrentItem(with: AVPlayerItem(url: url))
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
}
