// Swift in Practice — Edition #42: Restoring Focus After Playback on tvOS
// Section: Selection and focus are different facts
// https://swiftinpractice.com/editions/42-tvos-focus-after-playback/#selection-and-focus-are-different-facts

import AVKit
import SwiftUI

struct ShelfTitle: Identifiable {
    let id: String
    let title: String
    let mediaURL: URL
}

struct VideoShelf: View {
    let titles: [ShelfTitle]
    @Namespace private var shelfFocus
    @Environment(\.resetFocus) private var resetFocus
    @State private var playing: ShelfTitle?
    @State private var lastPlayedID: ShelfTitle.ID?

    private var preferredID: ShelfTitle.ID? {
        titles.first { $0.id == lastPlayedID }?.id ?? titles.first?.id
    }

    var body: some View {
        let targetID = preferredID

        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 28) {
                    ForEach(titles) { item in
                        Button(item.title) {
                            lastPlayedID = item.id
                            playing = item
                        }
                        .id(item.id)
                        .prefersDefaultFocus(item.id == targetID, in: shelfFocus)
                    }
                }
            }
            .focusScope(shelfFocus)
            .fullScreenCover(item: $playing, onDismiss: {
                if let preferredID { proxy.scrollTo(preferredID, anchor: .center) }
                resetFocus(in: shelfFocus)
            }) { item in
                ShelvedPlayback(url: item.mediaURL)
            }
        }
    }
}

private struct ShelvedPlayback: View {
    let url: URL
    @State private var player = AVPlayer()

    var body: some View {
        VideoPlayer(player: player)
            .task(id: url) {
                player.replaceCurrentItem(with: AVPlayerItem(url: url))
                player.play()
            }
            .onDisappear { player.pause() }
    }
}
