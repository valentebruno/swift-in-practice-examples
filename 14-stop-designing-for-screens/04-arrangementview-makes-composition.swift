// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: ArrangementView makes composition explicit
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#arrangementview-makes-composition-explicit

struct VideoPlayerView: View {
    let review: Review?
    let onSeek: (Duration) -> Void

    var body: some View {
        VideoSurface(videoURL: review?.videoURL)
            .overlay(alignment: .bottom) {
                PlaybackScrubber(
                    value: review?.playhead ?? .zero,
                    onChange: onSeek
                )
            }
    }
}

struct ReviewToolsView: View {
    let review: Review?
    let onSeek: (Duration) -> Void
    let onNotesChange: (String) -> Void

    var body: some View {
        Form {
            Section("Playback") {
                PlaybackPositionView(
                    value: review?.playhead ?? .zero,
                    onChange: onSeek
                )
            }
            // … the Notes section, not shown in the image
        }
    }
}
