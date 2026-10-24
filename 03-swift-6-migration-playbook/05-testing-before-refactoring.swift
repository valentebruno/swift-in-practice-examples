// Swift in Practice — Edition #3: Swift 6 Migration Playbook: How We Moved Three Production Apps Without Halting Feature Delivery
// Section: 2. Testing Before Refactoring
// https://swiftinpractice.com/editions/3-swift-6-migration-playbook/#2-testing-before-refactoring

// MARK: - Usage Example
func example() async {
    let service = ModernNetworkService()

    do {
        let data = try await service.fetchData()
        print("Data fetched successfully: \(data.count) bytes")
    } catch {
        print("Error fetching data: \(error)")
    }
}

// MARK: - Alternative: More Flexible Implementation
actor FlexibleNetworkService {
    private let legacyService = LegacyNetworkService()
    private var cache: Data?

    /// Fetches data with optional caching
    func fetchData(useCache: Bool = true) async throws -> Data {
        if useCache, let cached = cache {
            return cached
        }

        let data = try await withCheckedThrowingContinuation { continuation in
            self.legacyService.fetchData { result in
                continuation.resume(with: result)
            }
        }

        self.cache = data
        return data
    }

    func clearCache() {
        cache = nil
    }
}
}
