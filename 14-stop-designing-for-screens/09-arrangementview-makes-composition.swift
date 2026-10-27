// Swift in Practice — Edition #14: Stop Designing for Screens
// Section: ArrangementView makes composition explicit
// https://swiftinpractice.com/editions/14-stop-designing-for-screens/#arrangementview-makes-composition-explicit

@MainActor
@Observable
final class ReviewStore {
    private let repository: any ReviewRepository
    private(set) var review: Review?
    private(set) var isLoading = false
    private(set) var error: Error?
    var isPresentingTools = false

    init(repository: any ReviewRepository) {
        self.repository = repository
    }

    func load(id: UUID) async {
        isLoading = true
        error = nil
        defer { isLoading = false }
        do {
            review = try await repository.load(id: id)
        } catch {
            self.error = error
        }
    }

    func send(_ action: ReviewAction) {
        switch action {
        case .seek(let position):
            review?.playhead = position
        case .updateNotes(let notes):
            review?.notes = notes
        case .showTools:
            isPresentingTools = true
        case .hideTools:
            isPresentingTools = false
        }
    }

    func save() async {
        guard let review else { return }
        do {
            try await repository.save(review)
        } catch {
            self.error = error
        }
    }
}
