// Swift in Practice — Edition #20: The Work Is Cancelled. The Cleanup Isn’t.
// Section: The failure, in a few lines
// https://swiftinpractice.com/editions/20-cancellation-shields-and-cleanup-ownership/#the-failure-in-a-few-lines

import Foundation

actor EventLog {
    private(set) var entries: [String] = []
    func record(_ entry: String) { entries.append(entry) }
}

func releaseLease(_ log: EventLog) async {
    do {
        try await Task.sleep(for: .milliseconds(20))   // stands in for a network call
        await log.record("released")
    } catch {
        await log.record("release skipped: \(type(of: error))")
    }
}

func exportWithoutShield(_ log: EventLog) async throws {
    defer { await releaseLease(log) }
    try await Task.sleep(for: .seconds(5))             // the cancellable work
}
