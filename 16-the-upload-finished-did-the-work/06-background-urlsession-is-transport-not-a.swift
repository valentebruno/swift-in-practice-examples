// Swift in Practice — Edition #16: The Upload Finished. Did the Work?
// Section: Background URLSession Is Transport, Not a Workflow Engine
// https://swiftinpractice.com/editions/16-the-upload-finished-did-the-work/#background-urlsession-is-transport-not-a-workflow-engine

// AppDelegate
func application(
    _ application: UIApplication,
    handleEventsForBackgroundURLSession identifier: String,
    completionHandler: @escaping () -> Void
) {
    // 1. Keep the handler.
    SessionEvents.shared.completion = completionHandler
    // 2. Same identifier, so pending events can arrive.
    UploadSession.recreate(identifier: identifier)
}

// URLSessionDelegate
func urlSessionDidFinishEvents(
    forBackgroundURLSession session: URLSession
) {
    Task {
        // 3. Every observation reaches the ledger first...
        await coordinator.drainObservations()
        await MainActor.run {
            // ...then the system may snapshot the new UI.
            SessionEvents.shared.completion?()
            SessionEvents.shared.completion = nil
        }
    }
}
