// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: ArrangementView makes composition explicit
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#arrangementview-makes-composition-explicit

@MainActor
final class ReviewStoreTests: XCTestCase {

    func testSeekingUpdatesTheReviewWithoutKnowingTheLayout() async throws {
        let id = UUID()
        let review = Review(
            id: id,
            videoURL: URL(fileURLWithPath: "/tmp/review.mov"),
            playhead: .zero,
            notes: ""
        )

        let repository = LiveReviewRepository(storage: [id: review])
        let store = ReviewStore(repository: repository)

        await store.load(id: id)
        store.send(.seek(.seconds(42)))

        XCTAssertEqual(
            store.review?.playhead,
            .seconds(42)
        )
    }
}
