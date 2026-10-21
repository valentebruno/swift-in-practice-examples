// Swift in Practice — Edition #2: Swift Concurrency: What I Wish Someone Had Told Me
// Section: 3. Actor Reentrancy: The Bug That Looks Like Clean Code
// https://swiftinpractice.pages.dev/editions/2-swift-concurrency-what-i-wish-someone-had-told-me/#3-actor-reentrancy-the-bug-that-looks-like-clean-code

// My original attempt: the infamous "check twice" hack
actor DataManager {
    private var cache: [String: Data] = [:]

    func getData(for key: String) async -> Data {
        if let cached = cache[key] {
            return cached
        }

        let data = await fetchFromNetwork(key)

        // Check again in case another task already fetched and cached it
        if let cachedAgain = cache[key] {
            return cachedAgain
        }

        cache[key] = data
        return data
    }
}
