// Swift in Practice — Edition #18: Your App Is Showing the Truth. Just Not the Current One.
// Section: Relevance is a different question
// https://swiftinpractice.com/editions/18-state-freshness-and-causal-order/#relevance-is-a-different-question

import Foundation
import Observation

protocol FlightLoading: Sendable {
    func load(flightID: UUID) async throws -> FlightSnapshot
}

@MainActor
@Observable
final class FlightScreenModel {
    private(set) var visible: FlightSnapshot?
    private(set) var loadFailed = false

    private let loader: any FlightLoading
    private var selection: UInt64 = 0
    private var loadTask: Task<Void, Never>?

    init(loader: any FlightLoading) {
        self.loader = loader
    }

    func select(flightID: UUID) {
        selection += 1
        let token = selection

        loadTask?.cancel()
        visible = nil
        loadFailed = false

        loadTask = Task {
            do {
                let snapshot = try await loader.load(flightID: flightID)
                guard token == selection else { return }
                guard snapshot.flightID == flightID else {
                    loadFailed = true
                    return
                }
                visible = snapshot
            } catch {
                guard token == selection else { return }
                loadFailed = !(error is CancellationError)
            }
        }
    }
}
