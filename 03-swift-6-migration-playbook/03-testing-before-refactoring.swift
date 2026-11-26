// Swift in Practice — Edition #3: Swift 6 Migration Playbook: How We Moved Three Production Apps Without Halting Feature Delivery
// Section: 2. Testing Before Refactoring
// https://swiftinpractice.com/editions/3-swift-6-migration-playbook/#2-testing-before-refactoring

// MARK: - Legacy Service (Callback-based)
class LegacyNetworkService {
    func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.success(Data([0x01])))  // fixture for this example
    }
}
