// Swift in Practice — Edition #13: From Prototype to Client Delivery: Structuring Swift Projects That Don’t Break
// Section: The Networking Layer (With Modern Swift Concurrency)
// https://swiftinpractice.pages.dev/editions/13-from-prototype-to-client-delivery/#the-networking-layer-with-modern-swift-concurrency

// Models.swift - Make credentials a proper Sendable struct
struct LoginCredentials: Codable, Sendable {
    let email: String
    let password: String
}

// APIEndpoint.swift
enum APIEndpoint: Sendable {
    case login(LoginCredentials)
    case fetchProfile
    case updateSettings(Settings)

    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .fetchProfile: return "/user/profile"
        case .updateSettings: return "/user/settings"
        }
    }

    var method: String {
        switch self {
        case .login, .updateSettings: return "POST"
        case .fetchProfile: return "GET"
        }
    }

    func body() throws -> Data? {
        switch self {
        case .login(let credentials):
            return try JSONEncoder().encode(credentials)
        case .updateSettings(let settings):
            return try JSONEncoder().encode(settings)
        case .fetchProfile:
            return nil
        }
    }
}

// APIClient.swift - Thread-safe with actor
actor APIClient {
    private let baseURL: String
    private let session: URLSession
    private var authToken: String?

    init(baseURL: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func setAuthToken(_ token: String) {
        self.authToken = token
    }

    func request<T: Codable & Sendable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.httpBody = try endpoint.body()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add auth token if available
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}

enum NetworkError: Error, Sendable {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingFailed
}
