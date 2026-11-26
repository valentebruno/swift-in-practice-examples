// Swift in Practice — Edition #28: From Swift to SQL: Preserving the Meaning of Your Query
// Section: The half of the query that lives in the app
// https://swiftinpractice.com/editions/28-swift-to-sql-query-semantics/#the-half-of-the-query-that-lives-in-the-app

import Observation

protocol ArticleFeedFetching: Sendable {
    func page(
        scope: FeedScope, after cursor: String?, limit: Int
    ) async throws -> ArticlePage
}

@MainActor
@Observable
final class FeedModel {
    private(set) var articles: [ArticleSummary] = []
    private(set) var reachedEnd = false
    private(set) var needsRestart = false

    private let fetcher: any ArticleFeedFetching
    private var scope: FeedScope
    private var cursor: String?
    private var generation = 0
    private var isLoading = false

    init(scope: FeedScope, fetcher: any ArticleFeedFetching) {
        self.scope = scope
        self.fetcher = fetcher
    }

    func switchScope(to newScope: FeedScope) {
        guard newScope != scope else { return }
        generation += 1
        scope = newScope
        cursor = nil
        articles = []
        reachedEnd = false
        needsRestart = false
        isLoading = false
    }

    func loadNextPage() async {
        guard !isLoading, !reachedEnd else { return }
        isLoading = true
        let requested = generation

        do {
            let page = try await fetcher.page(
                scope: scope, after: cursor, limit: 30
            )
            guard requested == generation else { return }

            var known = Set(articles.map(\.id))
            for article in page.articles
            where known.insert(article.id).inserted {
                articles.append(article)
            }
            cursor = page.nextCursor
            reachedEnd = page.nextCursor == nil
        } catch {
            guard requested == generation else { return }
            needsRestart = true
        }
        isLoading = false
    }
}
