// Swift in Practice — Edition #13: From Prototype to Client Delivery: Structuring Swift Projects That Don’t Break
// Section: Rule 2: Embrace Swift Concurrency (Stop Fighting It)
// https://swiftinpractice.com/editions/13-from-prototype-to-client-delivery/#rule-2-embrace-swift-concurrency-stop-fighting-it

// Mark your service as Sendable for Swift 6 strict concurrency
protocol NetworkService: Sendable {
    func fetchUserProfile() async throws -> User
}

actor APINetworkService: NetworkService {
    private let baseURL: String
    private let session: URLSession

    init(baseURL: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func fetchUserProfile() async throws -> User {
        // Clean async/await
        // Automatic cancellation
        // Thread-safe by default
        let endpoint = APIEndpoint.fetchProfile
        return try await request(endpoint)
    }
}

@MainActor
@Observable  // Swift 5.9+ Observation framework
class ProfileViewModel {
    private let networkService: any NetworkService
    var user: User?
    var isLoading = false
    var errorMessage: String?

    init(networkService: any NetworkService) {
        self.networkService = networkService
    }

    func loadProfile() async {
        isLoading = true
        errorMessage = nil

        do {
            user = try await networkService.fetchUserProfile()
        } catch {
            errorMessage = "Failed to load profile: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
