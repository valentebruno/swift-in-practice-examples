// Swift in Practice — Edition #20: The Work Is Cancelled. The Cleanup Isn’t.
// Section: Name the obligation when you acquire the resource
// https://swiftinpractice.com/editions/20-cancellation-shields-and-cleanup-ownership/#name-the-obligation-when-you-acquire-the-resource

struct Lease: Hashable, Sendable {
    let id: UUID
}

protocol LeaseService: Sendable {
    func acquire() async throws -> Lease
    func release(_ lease: Lease) async throws
}

protocol PendingReleaseStore: Sendable {
    func add(_ lease: Lease) async
    func remove(_ lease: Lease) async
    func all() async -> [Lease]
}

@available(macOS 27.0, iOS 27.0, tvOS 27.0, watchOS 27.0, visionOS 27.0, *)
func withLease<Value: Sendable>(
    from service: any LeaseService,
    pending: any PendingReleaseStore,
    isolation: isolated (any Actor)? = #isolation,
    operation: (Lease) async throws -> Value
) async throws -> Value {
    let lease = try await service.acquire()
    await pending.add(lease)                 // the obligation exists from this line

    defer {
        await withTaskCancellationShield {
            do {
                try await service.release(lease)
                await pending.remove(lease)
            } catch {
                // The lease stays in the pending store for the recovery pass.
            }
        }
    }

    try Task.checkCancellation()
    return try await operation(lease)
}

func recoverPendingReleases(
    service: any LeaseService,
    pending: any PendingReleaseStore
) async {
    for lease in await pending.all() {
        if (try? await service.release(lease)) != nil {
            await pending.remove(lease)
        }
    }
}
