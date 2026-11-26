// Swift in Practice — Edition #28: From Swift to SQL: Preserving the Meaning of Your Query
// Section: Write the promise before the query
// https://swiftinpractice.com/editions/28-swift-to-sql-query-semantics/#write-the-promise-before-the-query

import Foundation

struct ArticleSummary: Identifiable, Equatable, Sendable {
    let id: UUID
    let title: String
    let publishedAt: Date
}

struct ArticlePage: Sendable {
    let articles: [ArticleSummary]
    let nextCursor: String?
}

struct FeedScope: Hashable, Sendable {
    let workspaceID: UUID
    let filter: String
}
