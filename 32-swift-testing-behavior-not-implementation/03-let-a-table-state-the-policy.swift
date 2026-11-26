// Swift in Practice — Edition #32: Swift Testing: Test Behavior, Not Implementation
// Section: Let a table state the policy
// https://swiftinpractice.com/editions/32-swift-testing-behavior-not-implementation/#let-a-table-state-the-policy

enum Connection: Sendable { case online, offline }

struct CachePolicyCase: Sendable, CustomTestStringConvertible {
    let connection: Connection
    let cached: [String]?
    let expected: [String]?        // nil means offline with no cache

    var testDescription: String {
        "\(connection), cache \(cached == nil ? "empty" : "present")"
    }
}

@Test("Cache policy", arguments: [
    CachePolicyCase(connection: .online, cached: ["Old"], expected: ["New"]),
    CachePolicyCase(connection: .offline, cached: ["Old"], expected: ["Old"]),
    CachePolicyCase(connection: .offline, cached: nil, expected: nil),
])
func cachePolicy(_ row: CachePolicyCase) async throws {
    let api: any FeedAPI = row.connection == .online
        ? ServingAPI(articles: ["New"]) : OfflineAPI()
    let loader = FeedLoader(api: api, cached: row.cached)

    if let expected = row.expected {
        #expect(try await loader.load() == expected)
    } else {
        await #expect(throws: URLError(.notConnectedToInternet)) { try await loader.load() }
    }
}
