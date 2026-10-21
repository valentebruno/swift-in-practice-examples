// Swift in Practice — Edition #3: Swift 6 Migration Playbook: How We Moved Three Production Apps Without Halting Feature Delivery
// Section: 2. Testing Before Refactoring
// https://swiftinpractice.pages.dev/editions/3-swift-6-migration-playbook/#2-testing-before-refactoring

func testConcurrentAccess() async throws {
    let manager = DataManager()
    await withThrowingTaskGroup(of: Void.self) { group in
        for i in 0..<100 {
            group.addTask { try await manager.load(id: i) }
        }
        for try await _ in group {}
    }
}
