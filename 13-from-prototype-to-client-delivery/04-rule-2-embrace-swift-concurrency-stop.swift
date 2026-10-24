// Swift in Practice — Edition #13: From Prototype to Client Delivery: Structuring Swift Projects That Don’t Break
// Section: Rule 2: Embrace Swift Concurrency (Stop Fighting It)
// https://swiftinpractice.com/editions/13-from-prototype-to-client-delivery/#rule-2-embrace-swift-concurrency-stop-fighting-it

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchUserProfile(completion: @escaping (Result<User, Error>) -> Void) {
        // Completion handler pyramid of doom
        // No structured concurrency
        // Hard to cancel
        // Testing nightmare
    }
}

// And now you're stuck with this everywhere:
class ProfileViewModel: ObservableObject {
    @Published var user: User?

    func loadProfile() {
        NetworkManager.shared.fetchUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                case .failure(let error):
                    // Error handling
                }
            }
        }
    }
}
