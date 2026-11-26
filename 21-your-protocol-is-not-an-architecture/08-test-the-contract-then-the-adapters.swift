// Swift in Practice — Edition #21: Your Protocol Is Not an Architecture
// Section: Test the contract, then the adapters
// https://swiftinpractice.com/editions/21-your-protocol-is-not-an-architecture/#test-the-contract-then-the-adapters

struct ContractViolation: Error, Equatable {
    let rule: String
}

func verifyArticleLoadingContract(_ loader: some ArticleLoading) async throws {
    let first = try await loader.load()
    let second = try await loader.load()

    guard first.map(\.id) == second.map(\.id) else {
        throw ContractViolation(rule: "order is stable between calls")
    }
    guard Set(first.map(\.id)).count == first.count else {
        throw ContractViolation(rule: "identifiers are unique")
    }

    let cancelled = Task {
        try await loader.load()
    }
    cancelled.cancel()
    if let partial = try? await cancelled.value, partial != first {
        throw ContractViolation(rule: "cancellation never yields partial data")
    }
}
