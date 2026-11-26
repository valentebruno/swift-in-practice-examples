// Swift in Practice — Edition #32: Swift Testing: Test Behavior, Not Implementation
// Section: Make waiting explicit
// https://swiftinpractice.com/editions/32-swift-testing-behavior-not-implementation/#make-waiting-explicit

protocol FeedObserver: Sendable {
    func feedDidRefresh()
}

struct RefreshingLoader: Sendable {
    let loader: FeedLoader
    let observer: any FeedObserver

    func refresh() async throws {
        _ = try await loader.load()
        observer.feedDidRefresh()
    }
}

struct CallbackObserver: FeedObserver {
    let onRefresh: @Sendable () -> Void
    func feedDidRefresh() { onRefresh() }
}

@Test("A refresh notifies the observer exactly once")
func refreshNotifiesOnce() async throws {
    try await confirmation(expectedCount: 1) { refreshed in
        let observer = CallbackObserver { refreshed() }
        let loader = RefreshingLoader(
            loader: FeedLoader(api: ServingAPI(articles: ["A"]), cached: nil),
            observer: observer)
        try await loader.refresh()
    }
}
