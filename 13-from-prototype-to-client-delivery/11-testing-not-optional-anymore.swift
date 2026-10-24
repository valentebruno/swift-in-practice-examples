// Swift in Practice — Edition #13: From Prototype to Client Delivery: Structuring Swift Projects That Don’t Break
// Section: Testing: Not Optional Anymore
// https://swiftinpractice.com/editions/13-from-prototype-to-client-delivery/#testing-not-optional-anymore

import Testing  // Swift Testing framework (better than XCTest)

// Protocol for your service
protocol AuthServiceProtocol: Sendable {
    func login(email: String, password: String) async throws -> User
}

@Suite("Login ViewModel Tests")
struct LoginViewModelTests {

    @MainActor
    @Test("Successful login updates user state")
    func successfulLogin() async throws {
        // Given
        let mockService = MockAuthService(shouldSucceed: true)
        let viewModel = LoginViewModel(authService: mockService)

        // When
        await viewModel.login(email: "test@example.com", password: "password123")

        // Then
        #expect(viewModel.isLoggedIn)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.user?.email == "test@example.com")
    }

    @MainActor
    @Test("Failed login shows error message")
    func failedLogin() async throws {
        // Given
        let mockService = MockAuthService(shouldSucceed: false)
        let viewModel = LoginViewModel(authService: mockService)

        // When
        await viewModel.login(email: "wrong@example.com", password: "wrong")

        // Then
        #expect(!viewModel.isLoggedIn)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.user == nil)
    }

    @MainActor
    @Test("Loading state is managed correctly")
    func loadingState() async throws {
        // Given
        let mockService = SlowMockAuthService()
        let viewModel = LoginViewModel(authService: mockService)

        // When
        async let loginTask: Void = viewModel.login(email: "test@example.com", password: "password")

        // Then - should be loading
        try await Task.sleep(for: .milliseconds(50))
        #expect(viewModel.isLoading)

        // Wait for completion
        await loginTask
        #expect(!viewModel.isLoading)
    }
}

// Mock service conforming to Sendable
actor MockAuthService: AuthServiceProtocol {
    private let shouldSucceed: Bool

    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }

    func login(email: String, password: String) async throws -> User {
        guard shouldSucceed else {
            throw AuthError.invalidCredentials
        }
        return User(id: "123", email: email, name: "Test User")
    }
}

actor SlowMockAuthService: AuthServiceProtocol {
    func login(email: String, password: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(100))
        return User(id: "123", email: email, name: "Test User")
    }
}
