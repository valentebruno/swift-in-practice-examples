// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: ArrangementView makes composition explicit
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#arrangementview-makes-composition-explicit

@MainActor
struct ReviewScreen: View {
    @State private var store: ReviewStore
    private let reviewID: UUID

    init(
        reviewID: UUID,
        repository: any ReviewRepository
    ) {
        self.reviewID = reviewID
        _store = State(
            initialValue: ReviewStore(repository: repository)
        )
    }

    var body: some View {
        ReviewComposition(store: store)
            .task(id: reviewID) {
                await store.load(id: reviewID)
            }
    }
}
