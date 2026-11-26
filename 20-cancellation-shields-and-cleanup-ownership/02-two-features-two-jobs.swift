// Swift in Practice — Edition #20: The Work Is Cancelled. The Cleanup Isn’t.
// Section: Two features, two jobs
// https://swiftinpractice.com/editions/20-cancellation-shields-and-cleanup-ownership/#two-features-two-jobs

@available(macOS 27.0, iOS 27.0, tvOS 27.0, watchOS 27.0, visionOS 27.0, *)
func exportWithShield(_ log: EventLog) async throws {
    defer {
        await withTaskCancellationShield {
            await log.record("in shield: isCancelled=\(Task.isCancelled)")
            await releaseLease(log)
        }
        await log.record("after shield: isCancelled=\(Task.isCancelled)")
    }
    try await Task.sleep(for: .seconds(5))
}
