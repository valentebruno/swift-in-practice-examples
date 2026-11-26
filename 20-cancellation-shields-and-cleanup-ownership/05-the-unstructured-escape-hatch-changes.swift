// Swift in Practice — Edition #20: The Work Is Cancelled. The Cleanup Isn’t.
// Section: The unstructured escape hatch changes the contract
// https://swiftinpractice.com/editions/20-cancellation-shields-and-cleanup-ownership/#the-unstructured-escape-hatch-changes-the-contract

func exportWithDetachedCleanup(_ log: EventLog) async throws {
    defer {
        Task { await releaseLease(log) }
    }
    try await Task.sleep(for: .seconds(5))
}
