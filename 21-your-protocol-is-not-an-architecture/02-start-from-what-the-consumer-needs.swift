// Swift in Practice — Edition #21: Your Protocol Is Not an Architecture
// Section: Start from what the consumer needs
// https://swiftinpractice.com/editions/21-your-protocol-is-not-an-architecture/#start-from-what-the-consumer-needs

import Foundation

struct Article: Identifiable, Equatable, Sendable {
    let id: UUID
    let title: String
}

/// Loads the articles for the reader's home feed.
///
/// - Returns articles newest first; the order is stable between calls
///   when the underlying data has not changed.
/// - An empty array is a successful result: the feed has no articles.
/// - Throws `CancellationError` if the calling task is cancelled.
///   Cancellation abandons the request; it never returns partial data.
protocol ArticleLoading: Sendable {
    func load() async throws -> [Article]
}

struct ArticleFeed<Loader: ArticleLoading>: Sendable {
    let loader: Loader

    func refresh() async throws -> [Article] {
        try await loader.load()
    }
}
