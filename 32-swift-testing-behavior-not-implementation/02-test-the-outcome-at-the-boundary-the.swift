// Swift in Practice — Edition #32: Swift Testing: Test Behavior, Not Implementation
// Section: Test the outcome at the boundary the caller sees
// https://swiftinpractice.com/editions/32-swift-testing-behavior-not-implementation/#test-the-outcome-at-the-boundary-the-caller-sees

struct FeedLoader: Sendable {
    let api: any FeedAPI
    let cached: [String]?

    func load() async throws -> [String] {
        do {
            return try await api.latest()
        } catch let error as URLError
            where error.code == .notConnectedToInternet {
            guard let cached else { throw error }
            return cached
        }
    }
}

struct OfflineAPI: FeedAPI {
    func latest() async throws -> [String] {
        throw URLError(.notConnectedToInternet)
    }
}

struct ServingAPI: FeedAPI {
    let articles: [String]
    func latest() async throws -> [String] { articles }
}

@Test("Offline, the reader keeps the last feed they saw")
func offlineShowsLastKnownFeed() async throws {
    let loader = FeedLoader(api: OfflineAPI(), cached: ["Issue 16"])
    #expect(try await loader.load() == ["Issue 16"])
}

@Test("Offline with nothing cached, the reader gets a recoverable error")
func offlineWithoutCacheThrows() async {
    let loader = FeedLoader(api: OfflineAPI(), cached: nil)
    await #expect(throws: URLError.self) { try await loader.load() }
}

@Test("An empty feed is a result, not a failure")
func emptyFeedIsSuccess() async throws {
    let loader = FeedLoader(api: ServingAPI(articles: []), cached: ["Issue 16"])
    #expect(try await loader.load() == [])
}
