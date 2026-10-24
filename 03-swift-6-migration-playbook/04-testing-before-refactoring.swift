// Swift in Practice — Edition #3: Swift 6 Migration Playbook: How We Moved Three Production Apps Without Halting Feature Delivery
// Section: 2. Testing Before Refactoring
// https://swiftinpractice.com/editions/3-swift-6-migration-playbook/#2-testing-before-refactoring

// MARK: - Modern Service (Async/Await)
actor ModernNetworkService {
    private let legacyService = LegacyNetworkService()

    /// Fetches data using modern async/await while wrapping legacy callback API
    func fetchData() async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            self.legacyService.fetchData { result in
                continuation.resume(with: result)
            }
        }
    }
}
