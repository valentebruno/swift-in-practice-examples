// Swift in Practice — Edition #32: Swift Testing: Test Behavior, Not Implementation
// Section: The test that records the wiring
// https://swiftinpractice.com/editions/32-swift-testing-behavior-not-implementation/#the-test-that-records-the-wiring

import Foundation
import Testing

protocol FeedAPI: Sendable {
    func latest() async throws -> [String]
}

final class RecordingAPI: FeedAPI, @unchecked Sendable {
    var calls: [String] = []
    func latest() async throws -> [String] {
        calls.append("latest")
        throw URLError(.notConnectedToInternet)
    }
}
