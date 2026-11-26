// Swift in Practice — Edition #16: The Upload Finished. Did the Work?
// Section: Background URLSession Is Transport, Not a Workflow Engine
// https://swiftinpractice.com/editions/16-the-upload-finished-did-the-work/#background-urlsession-is-transport-not-a-workflow-engine

import Synchronization

final class TransferObservations: Sendable {
    private let tail = Mutex<Task<Void, Never>?>(nil)

    func enqueue(_ observation: @escaping @Sendable () async -> Void) {
        tail.withLock { task in
            let previous = task
            task = Task {
                await previous?.value
                await observation()
            }
        }
    }
}

// Keep one observations queue per session. Enqueue from its serial delegate queue.
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
    let status = response?.statusCode
    observations.enqueue {
        await coordinator.observeTransferEnded(id, status: status, error: error)
    }
}
