// Swift in Practice — Edition #3: Swift 6 Migration Playbook: How We Moved Three Production Apps Without Halting Feature Delivery
// Section: 2. Testing Before Refactoring
// https://swiftinpractice.com/editions/3-swift-6-migration-playbook/#2-testing-before-refactoring

// MARK: - Legacy Service (Callback-based)
class LegacyNetworkService {
    func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
        // Legacy implementation
    }
}
Adapters bought us time. Old code stayed safe, new code shipped modern. Velocity never stopped.
