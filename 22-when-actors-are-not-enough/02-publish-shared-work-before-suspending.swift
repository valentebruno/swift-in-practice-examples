// Swift in Practice — Edition #22: When Actors Are Not Enough: Reentrancy and State Ownership
// Section: Publish shared work before suspending
// https://swiftinpractice.com/editions/22-when-actors-are-not-enough/#publish-shared-work-before-suspending

enum SessionError: Error {
    case signedOut
    case sessionChanged
}

actor TokenStore {
    private struct Flight {
        let id: UUID
        let task: Task<AuthToken, any Error>
    }

    private let api: any AuthAPI
    private var token: AuthToken?
    private var session = UUID()
    private var flight: Flight?

    init(api: any AuthAPI, token: AuthToken?) {
        self.api = api
        self.token = token
    }

    func validToken(at now: Date) async throws -> AuthToken {
        try Task.checkCancellation()
        guard let token else { throw SessionError.signedOut }
        let expectedSession = session

        let current: Flight
        if let flight {
            current = flight
        } else {
            guard token.expiresAt <= now else { return token }
            let task = Task { [api, refreshToken = token.refreshToken] in
                try await api.refresh(refreshToken)
            }
            current = Flight(id: UUID(), task: task)
            flight = current
        }

        let result = await current.task.result
        guard session == expectedSession else {
            throw SessionError.sessionChanged
        }
        if flight?.id == current.id {
            flight = nil
            if case .success(let refreshed) = result {
                self.token = refreshed
            }
        }

        try Task.checkCancellation()
        _ = try result.get()
        guard let committed = self.token else {
            throw SessionError.signedOut
        }
        return committed
    }

    func replaceSession(with replacement: AuthToken?) {
        session = UUID()
        token = replacement
        flight?.task.cancel()
        flight = nil
    }
}
