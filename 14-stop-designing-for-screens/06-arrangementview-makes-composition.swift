// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: ArrangementView makes composition explicit
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#arrangementview-makes-composition-explicit

@available(iOS 27.1, iPadOS 27.1, *)
private struct ModernReviewComposition: View {
    let store: ReviewStore

    var body: some View {
        ArrangementView {
            VideoPlayerView(
                review: store.review,
                onSeek: { store.send(.seek($0)) }
            )
        } secondary: {
            ReviewToolsView(
                review: store.review,
                onSeek: { store.send(.seek($0)) },
                onNotesChange: { store.send(.updateNotes($0)) }
            )
        }
        .arrangementViewStyle(.split)
        .axes(.horizontal)
    }
}
