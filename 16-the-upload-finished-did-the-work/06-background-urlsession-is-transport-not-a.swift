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
    observations.enqueue {
        // 3. Every earlier callback has reached the ledger first.
        await MainActor.run {
            // ...then the system may snapshot the new UI.
            SessionEvents.shared.completion?()
            SessionEvents.shared.completion = nil
        }
    }
}
