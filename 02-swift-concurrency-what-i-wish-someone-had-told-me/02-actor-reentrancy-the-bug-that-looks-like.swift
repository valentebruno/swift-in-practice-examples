// Swift in Practice — Edition #2: Swift Concurrency: What I Wish Someone Had Told Me
// Section: 3. Actor Reentrancy: The Bug That Looks Like Clean Code
// https://swiftinpractice.com/editions/2-swift-concurrency-what-i-wish-someone-had-told-me/#3-actor-reentrancy-the-bug-that-looks-like-clean-code

actor DataManager {
    private var cache: [String: Data] = [:]

    func getData(for key: String) async -> Data {
        if let cached = cache[key] {
            return cached
        }

        let data = await fetchFromNetwork(key)
        cache[key] = data  // 🚨 BUG HIDING HERE
        return data
    }
}
