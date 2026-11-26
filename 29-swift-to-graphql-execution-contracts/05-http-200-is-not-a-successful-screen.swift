// Swift in Practice — Edition #29: From Swift to GraphQL: Understanding the Work Behind a Request
// Section: HTTP 200 is not a successful screen
// https://swiftinpractice.com/editions/29-swift-to-graphql-execution-contracts/#http-200-is-not-a-successful-screen

struct ArticleCard: Identifiable, Equatable, Sendable {
    let id: String
    let title: String
    let authorName: String?
}

struct ReadingListSnapshot: Equatable, Sendable {
    let articles: [ArticleCard]
    let unavailableAuthorCount: Int
}

enum ReadingListOutcome: Equatable, Sendable {
    case complete(ReadingListSnapshot)
    case partial(ReadingListSnapshot)
    case needsAuthentication
    case unavailable
}

func readingListOutcome(
    from response: GraphQLResponse<ReadingListData>
) -> ReadingListOutcome {
    let errors = response.errors ?? []

    if errors.contains(where: { $0.extensions?.code == "UNAUTHENTICATED" }) {
        return .needsAuthentication
    }
    guard let connection = response.data?.articles else {
        return .unavailable
    }

    let cards = connection.edges.map { edge in
        ArticleCard(
            id: edge.node.id,
            title: edge.node.title,
            authorName: edge.node.author?.displayName
        )
    }
    let snapshot = ReadingListSnapshot(
        articles: cards,
        unavailableAuthorCount: cards.count { $0.authorName == nil }
    )

    if errors.isEmpty { return .complete(snapshot) }

    let authorsAloneFailed = errors.allSatisfy { $0.path?.last == .field("author") }
    return authorsAloneFailed ? .partial(snapshot) : .unavailable
}
