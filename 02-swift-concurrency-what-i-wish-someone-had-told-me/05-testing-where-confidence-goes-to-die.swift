// Swift in Practice — Edition #2: Swift Concurrency: What I Wish Someone Had Told Me
// Section: 4. Testing: Where Confidence Goes to Die
// https://swiftinpractice.com/editions/2-swift-concurrency-what-i-wish-someone-had-told-me/#4-testing-where-confidence-goes-to-die

func testConcurrentAccess() async throws {
    let manager = DataManager()

    // Hammer it with 100 concurrent requests
    try await withThrowingTaskGroup(of: Data.self) { group in
        for _ in 0..<100 {
            group.addTask {
                try await manager.getData(for: "test")
            }
        }

        var completed = 0
        for try await _ in group { completed += 1 }
        precondition(completed == 100)
    }
}
