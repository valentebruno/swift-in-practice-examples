// Swift in Practice — Edition #27: A Fold Shouldn’t Restart Playback
// Section: Put the owner above every layout decision
// https://swiftinpractice.com/editions/27-audio-continuity-across-layout-changes/#put-the-owner-above-every-layout-decision

struct PlayerApp: App {
    @State private var session = PlaybackSession()

    var body: some Scene {
        WindowGroup {
            PlayerRoot(session: session)
        }
    }
}

struct PlayerRoot: View {
    let session: PlaybackSession

    var body: some View {
        GeometryReader { proxy in
            if proxy.size.width >= 700 {
                ExpandedPlayer(session: session)
            } else {
                CompactPlayer(session: session)
            }
        }
    }
}

struct CompactPlayer: View {
    let session: PlaybackSession

    var body: some View {
        TransportButton(session: session)
    }
}

struct ExpandedPlayer: View {
    let session: PlaybackSession

    var body: some View {
        HStack(spacing: 32) {
            RoundedRectangle(cornerRadius: 24).aspectRatio(1, contentMode: .fit)
            TransportButton(session: session)
        }
        .padding(32)
    }
}

struct TransportButton: View {
    let session: PlaybackSession

    var body: some View {
        Button(session.userWantsPlayback ? "Pause" : "Play") {
            if session.userWantsPlayback { session.pause() } else { session.play() }
        }
    }
}
