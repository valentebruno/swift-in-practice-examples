// Swift in Practice — Edition #21: Your Protocol Is Not an Architecture
// Section: Generic, opaque, or existential
// https://swiftinpractice.com/editions/21-your-protocol-is-not-an-architecture/#generic-opaque-or-existential

// Generic: the caller chooses the type; the relationship is preserved.
func firstTitle<L: ArticleLoading>(from loader: L) async throws -> String? {
    try await loader.load().first?.title
}

// Opaque: the implementation chooses one type and hides which.
func makeDefaultLoader() -> some ArticleLoading {
    StaticLoader(articles: [])
}

// Existential: the stored type can vary at runtime.
struct FeedRegistry {
    var loaders: [String: any ArticleLoading] = [:]
}

struct StaticLoader: ArticleLoading {
    let articles: [Article]
    func load() async throws -> [Article] { articles }
}
