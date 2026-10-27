// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: ArrangementView makes composition explicit
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#arrangementview-makes-composition-explicit

@Test
@MainActor
func loadingReviewUpdatesObservableState() async {
    let repository = MockReviewRepository(
        review: .fixture
    )
    let store = ReviewStore(
        repository: repository
    )
    await store.load(id: .fixture.id)
    #expect(store.review?.id == .fixture.id)
}

@Test
func repositoryPersistsReview() async throws {
    let repository = InMemoryReviewRepository()
    let review = Review.fixture
    try await repository.save(review)
    let loaded = try await repository.loadReview(id: review.id)
    #expect(loaded == review)
}
