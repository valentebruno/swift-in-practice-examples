// Swift in Practice — Edition #22: When Actors Are Not Enough: Reentrancy and State Ownership
// Section: The store that looks safe
// https://swiftinpractice.com/editions/22-when-actors-are-not-enough/#the-store-that-looks-safe

import Foundation

struct AuthToken: Sendable {
    let refreshToken: String
    let expiresAt: Date
}

protocol AuthAPI: Sendable {
    func refresh(_ token: String) async throws -> AuthToken
}

actor NaiveTokenStore {
    private let api: any AuthAPI
    private var token: AuthToken

    init(api: any AuthAPI, token: AuthToken) {
        self.api = api
        self.token = token
    }

    func validToken(at now: Date) async throws -> AuthToken {
        if token.expiresAt <= now {
            token = try await api.refresh(token.refreshToken)
        }
        return token
    }
}
