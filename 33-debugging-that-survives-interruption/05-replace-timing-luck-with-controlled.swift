// Swift in Practice — Edition #33: Your Debugging Session Should Survive an Interruption
// Section: Replace timing luck with controlled ordering
// https://swiftinpractice.com/editions/33-debugging-that-survives-interruption/#replace-timing-luck-with-controlled-ordering

actor ControlledService<Key: Hashable & Sendable, Value: Sendable> {
    private var pending: [Key: CheckedContinuation<Value, any Error>] = [:]
    private var arrivalWaiters: [Key: [CheckedContinuation<Void, Never>]] = [:]

    func request(_ key: Key) async throws -> Value {
        try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                if Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                    return
                }
                pending[key] = continuation
                arrivalWaiters.removeValue(forKey: key)?.forEach { $0.resume() }
            }
        } onCancel: {
            Task { await self.cancel(key) }
        }
    }

    func waitUntilRequested(_ key: Key) async {
        if pending[key] != nil { return }
        await withCheckedContinuation { waiter in
            arrivalWaiters[key, default: []].append(waiter)
        }
    }

    func complete(_ key: Key, with value: Value) {
        pending.removeValue(forKey: key)?.resume(returning: value)
    }

    func fail(_ key: Key, with error: any Error) {
        pending.removeValue(forKey: key)?.resume(throwing: error)
    }

    private func cancel(_ key: Key) {
        pending.removeValue(forKey: key)?.resume(throwing: CancellationError())
    }
}
