// Swift in Practice — Edition #33: Your Debugging Session Should Survive an Interruption
// Section: Log identity first, volume second
// https://swiftinpractice.com/editions/33-debugging-that-survives-interruption/#log-identity-first-volume-second

import Foundation
import os

struct InvestigationContext: Sendable {
    let operationID: UUID
    let selectionGeneration: UInt64
    let accountScope: String
}

enum Diagnostics {
    @TaskLocal static var context: InvestigationContext?

    static let feed = Logger(
        subsystem: "com.example.reader", category: "feed"
    )
}

func logResponseApplied(articleCount: Int) {
    guard let context = Diagnostics.context else { return }
    Diagnostics.feed.debug("""
        applied op=\(context.operationID, privacy: .public) \
        gen=\(context.selectionGeneration) \
        scope=\(context.accountScope, privacy: .public) \
        count=\(articleCount)
        """)
}

func loadFeed(
    generation: UInt64,
    accountScope: String,
    perform: @Sendable () async -> Int
) async {
    let context = InvestigationContext(
        operationID: UUID(),
        selectionGeneration: generation,
        accountScope: accountScope
    )
    await Diagnostics.$context.withValue(context) {
        let count = await perform()
        logResponseApplied(articleCount: count)
    }
}
