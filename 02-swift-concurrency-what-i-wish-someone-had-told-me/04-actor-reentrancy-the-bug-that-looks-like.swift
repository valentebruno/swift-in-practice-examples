// Swift in Practice — Edition #2: Swift Concurrency: What I Wish Someone Had Told Me
// Section: 3. Actor Reentrancy: The Bug That Looks Like Clean Code
// https://swiftinpractice.com/editions/2-swift-concurrency-what-i-wish-someone-had-told-me/#3-actor-reentrancy-the-bug-that-looks-like-clean-code

actor DataManager {
    private var cache: [String: Data] = [:]
    private var inflightRequests: [String: Task<Data, Error>] = [:]

    func getData(for key: String) async throws -> Data {
        if let cached = cache[key] { return cached }

        // If someone's already fetching this, just wait for them
        if let existingTask = inflightRequests[key] {
            return try await existingTask.value
        }

        // Start a new fetch
        let task = Task { try await fetchFromNetwork(key) }
        inflightRequests[key] = task

        do {
            let data = try await task.value
            cache[key] = data
            inflightRequests[key] = nil
            return data
        } catch {
            inflightRequests[key] = nil
            throw error
        }
    }
}
