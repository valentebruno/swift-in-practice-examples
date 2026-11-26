// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: ArrangementView makes composition explicit
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#arrangementview-makes-composition-explicit

import Foundation
import Testing

@Test
@MainActor
func loadingReviewUpdatesObservableState() async {
    let review = testReview()
    let repository = LiveReviewRepository(storage: [review.id: review])
    let store = ReviewStore(repository: repository)
    await store.load(id: review.id)
    #expect(store.review?.id == review.id)
}

private func testReview() -> Review {
    Review(
        id: UUID(),
        videoURL: URL(fileURLWithPath: "/tmp/review.mov"),
        playhead: .zero,
        notes: ""
    )
}

@Test
func repositorySavesAndLoadsReview() async throws {
    let repository = LiveReviewRepository()
    let review = testReview()
    try await repository.save(review)
    let loaded = try await repository.load(id: review.id)
    #expect(loaded == review)
}
