// Swift in Practice — Edition #13: From Prototype to Client Delivery: Structuring Swift Projects That Don’t Break
// Section: Good use of protocols (with modern Swift):
// https://swiftinpractice.pages.dev/editions/13-from-prototype-to-client-delivery/#good-use-of-protocols-with-modern-swift

// Protocol with associated types for better type safety
protocol DataStorage: Sendable {
    associatedtype StorageError: Error

    func save<T: Codable & Sendable>(_ value: T, forKey key: String) async throws
    func load<T: Codable & Sendable>(forKey key: String) async throws -> T?
    func delete(forKey key: String) async throws
}

// Actor-based storage for thread safety
actor UserDefaultsStorage: DataStorage {
    enum UserDefaultsError: Error {
        case encodingFailed
        case decodingFailed
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func save<T: Codable & Sendable>(_ value: T, forKey key: String) async throws {
        let data = try JSONEncoder().encode(value)
        userDefaults.set(data, forKey: key)
    }

    func load<T: Codable & Sendable>(forKey key: String) async throws -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }

    func delete(forKey key: String) async throws {
        userDefaults.removeObject(forKey: key)
    }
}

// Keychain storage for sensitive data
actor KeychainStorage: DataStorage {
    enum KeychainError: Error {
        case saveFailed(OSStatus)
        case loadFailed(OSStatus)
        case deleteFailed(OSStatus)
    }

    // Implementation using Security framework
    // Thread-safe by default thanks to actor
}
