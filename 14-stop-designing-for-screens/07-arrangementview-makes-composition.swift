// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: ArrangementView makes composition explicit
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#arrangementview-makes-composition-explicit

@MainActor
struct ReviewComposition: View {
    let store: ReviewStore

    var body: some View {
        if #available(iOS 27.1, iPadOS 27.1, *) {
            ModernReviewComposition(store: store)
        } else {
            LegacyReviewComposition(store: store)
        }
    }
}
