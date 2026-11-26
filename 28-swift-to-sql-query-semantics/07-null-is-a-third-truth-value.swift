// Swift in Practice — Edition #28: From Swift to SQL: Preserving the Meaning of Your Query
// Section: NULL is a third truth value
// https://swiftinpractice.com/editions/28-swift-to-sql-query-semantics/#null-is-a-third-truth-value

struct DraftSummary: Sendable {
    let id: UUID
    let title: String
    let publishedAt: Date?
}
