// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: ArrangementView makes composition explicit
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#arrangementview-makes-composition-explicit

@MainActor
private struct LegacyReviewComposition: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let store: ReviewStore

    var body: some View {
        if horizontalSizeClass == .regular {
            HStack(spacing: 0) {
                player
                    .frame(maxWidth: .infinity)
                tools
                    .frame(minWidth: 320)
            }
        } else {
            player
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Tools") {
                            store.send(.showTools)
                        }
                    }
                }
                .sheet(isPresented: toolsPresentation) {
                    tools
                }
        }
    }

    private var player: some View {
        VideoPlayerView(
            review: store.review,
            onSeek: { store.send(.seek($0)) }
        )
    }

    private var tools: some View {
        ReviewToolsView(
            review: store.review,
            onSeek: { store.send(.seek($0)) },
            onNotesChange: { store.send(.updateNotes($0)) }
        )
    }

    private var toolsPresentation: Binding<Bool> {
        Binding(
            get: { store.isPresentingTools },
            set: { store.send($0 ? .showTools : .hideTools) }
        )
    }
}
