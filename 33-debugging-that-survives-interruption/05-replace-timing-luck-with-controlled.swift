// Swift in Practice — Edition #33: Your Debugging Session Should Survive an Interruption
// Section: Replace timing luck with controlled ordering
// https://swiftinpractice.com/editions/33-debugging-that-survives-interruption/#replace-timing-luck-with-controlled-ordering

actor ControlledService<Key: Hashable & Sendable, Value: Sendable> {
    enum HarnessError: Error { case duplicatePendingRequest }

    private struct Pending {
        let id: UUID
        let continuation: CheckedContinuation<Value, any Error>
    }

    private var pending: [Key: Pending] = [:]
    private var arrivalWaiters: [Key: [CheckedContinuation<Void, Never>]] = [:]

    func request(_ key: Key) async throws -> Value {
        let id = UUID()
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                if Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                    return
                }
                guard pending[key] == nil else {
                    continuation.resume(throwing: HarnessError.duplicatePendingRequest)
                    return
                }
                pending[key] = Pending(id: id, continuation: continuation)
                arrivalWaiters.removeValue(forKey: key)?.forEach { $0.resume() }
            }
        } onCancel: {
            Task { await self.cancel(key, id: id) }
        }
    }

    func waitUntilRequested(_ key: Key) async {
        if pending[key] != nil { return }
        await withCheckedContinuation { waiter in
            arrivalWaiters[key, default: []].append(waiter)
        }
    }

    func complete(_ key: Key, with value: Value) {
        pending.removeValue(forKey: key)?.continuation.resume(returning: value)
    }

    func fail(_ key: Key, with error: any Error) {
        pending.removeValue(forKey: key)?.continuation.resume(throwing: error)
    }

    private func cancel(_ key: Key, id: UUID) {
        guard pending[key]?.id == id else { return }
        pending.removeValue(forKey: key)?.continuation.resume(throwing: CancellationError())
    }
}
