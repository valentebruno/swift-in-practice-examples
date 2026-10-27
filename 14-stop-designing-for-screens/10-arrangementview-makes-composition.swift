// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: ArrangementView makes composition explicit
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#arrangementview-makes-composition-explicit

protocol ReviewRepository: Sendable {
    func load(id: UUID) async throws -> Review
    func save(_ review: Review) async throws
}

actor LiveReviewRepository: ReviewRepository {
    private var storage: [UUID: Review]

    init(storage: [UUID: Review] = [:]) {
        self.storage = storage
    }

    func load(id: UUID) async throws -> Review {
        guard let review = storage[id] else {
            throw ReviewRepositoryError.notFound(id)
        }
        return review
    }

    func save(_ review: Review) async throws {
        storage[review.id] = review
    }
}

enum ReviewRepositoryError: Error {
    case notFound(UUID)
}
