// Swift in Practice — Edition #22: When Actors Are Not Enough: Reentrancy and State Ownership
// Section: Reproduce the interleaving
// https://swiftinpractice.com/editions/22-when-actors-are-not-enough/#reproduce-the-interleaving

import Testing

actor GatedAuthAPI: AuthAPI {
    private(set) var calls = 0
    private var gates: [CheckedContinuation<Void, Never>] = []
    private var callWaiters: [CheckedContinuation<Void, Never>] = []

    func refresh(_ token: String) async throws -> AuthToken {
        calls += 1
        callWaiters.forEach { $0.resume() }
        callWaiters = []
        await withCheckedContinuation { gates.append($0) }
        return AuthToken(refreshToken: "rotated", expiresAt: .distantFuture)
    }

    func waitForFirstCall() async {
        if calls > 0 { return }
        await withCheckedContinuation { callWaiters.append($0) }
    }

    func release() {
        gates.forEach { $0.resume() }
        gates = []
    }
}

@Test func concurrentCallersShareOneRefresh() async throws {
    let api = GatedAuthAPI()
    let expired = AuthToken(refreshToken: "old", expiresAt: .distantPast)
    let store = TokenStore(api: api, token: expired)

    async let a = store.validToken(at: .now)
    async let b = store.validToken(at: .now)
    async let c = store.validToken(at: .now)
    await api.waitForFirstCall()
    await api.release()

    let tokens = try await [a, b, c]
    #expect(tokens.map(\.refreshToken) == ["rotated", "rotated", "rotated"])
    #expect(await api.calls == 1)
}

@Test func aLateRefreshCannotRestoreASignedOutSession() async throws {
    let api = GatedAuthAPI()
    let expired = AuthToken(refreshToken: "old", expiresAt: .distantPast)
    let store = TokenStore(api: api, token: expired)

    let pending = Task { try await store.validToken(at: .now) }
    await api.waitForFirstCall()
    await store.replaceSession(with: nil)
    await api.release()

    await #expect(throws: SessionError.sessionChanged) { try await pending.value }
    await #expect(throws: SessionError.signedOut) { try await store.validToken(at: .now) }
}
