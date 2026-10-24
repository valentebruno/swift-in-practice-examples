// Swift in Practice — Edition #16: The Upload Finished. Did the Work?
// Section: Background URLSession Is Transport, Not a Workflow Engine
// https://swiftinpractice.com/editions/16-the-upload-finished-did-the-work/#background-urlsession-is-transport-not-a-workflow-engine

func urlSession(_ session: URLSession,
                task: URLSessionTask,
                didCompleteWithError error: Error?) {
    guard let raw = task.taskDescription,
          let id = UUID(uuidString: raw) else { return }
    let response = task.response as? HTTPURLResponse

    // An observation, not a verdict.
    // It may be a duplicate, late, or out of order.
    // A 2xx moves the item to .awaitingVerification,
    // never straight to .committed.
    Task {
        await coordinator.observeTransferEnded(
            id, status: response?.statusCode, error: error)
    }
}
