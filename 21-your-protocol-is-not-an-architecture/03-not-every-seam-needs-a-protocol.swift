// Swift in Practice — Edition #21: Your Protocol Is Not an Architecture
// Section: Not every seam needs a protocol
// https://swiftinpractice.com/editions/21-your-protocol-is-not-an-architecture/#not-every-seam-needs-a-protocol

struct FeedAction: Sendable {
    let load: @Sendable () async throws -> [Article]

    func callAsFunction() async throws -> [Article] {
        try await load()
    }
}
