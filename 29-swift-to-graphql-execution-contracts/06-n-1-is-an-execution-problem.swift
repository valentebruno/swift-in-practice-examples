// Swift in Practice — Edition #29: From Swift to GraphQL: Understanding the Work Behind a Request
// Section: N+1 is an execution problem
// https://swiftinpractice.com/editions/29-swift-to-graphql-execution-contracts/#n-1-is-an-execution-problem

struct AuthorRecord: Equatable, Sendable {
    let id: String
    let displayName: String
}

actor AuthorLoader {
    typealias BatchFetch = @Sendable (
        _ tenantID: UUID, _ ids: [String]
    ) async throws -> [String: AuthorRecord]

    private let tenantID: UUID
    private let fetch: BatchFetch
    private var waiting: [String: [CheckedContinuation<AuthorRecord?, any Error>]] = [:]
    private var resolved: [String: AuthorRecord?] = [:]
    private var flushScheduled = false

    init(tenantID: UUID, fetch: @escaping BatchFetch) {
        self.tenantID = tenantID
        self.fetch = fetch
    }

    func load(_ id: String) async throws -> AuthorRecord? {
        if let known = resolved[id] { return known }

        return try await withCheckedThrowingContinuation { continuation in
            waiting[id, default: []].append(continuation)
            if !flushScheduled {
                flushScheduled = true
                Task { await self.flush() }
            }
        }
    }

    private func flush() async {
        await Task.yield()
        let batch = waiting
        waiting = [:]
        flushScheduled = false

        do {
            let found = try await fetch(tenantID, Array(batch.keys))
            for (id, continuations) in batch {
                let record = found[id]
                resolved[id] = .some(record)
                continuations.forEach { $0.resume(returning: record) }
            }
        } catch {
            for continuations in batch.values {
                continuations.forEach { $0.resume(throwing: error) }
            }
        }
    }
}
