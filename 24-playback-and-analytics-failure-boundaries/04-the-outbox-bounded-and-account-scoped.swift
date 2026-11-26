// Swift in Practice — Edition #24: Should the Music Stop When Analytics Fails?
// Section: The outbox: bounded and account-scoped
// https://swiftinpractice.com/editions/24-playback-and-analytics-failure-boundaries/#the-outbox-bounded-and-account-scoped

enum DeliveryOutcome: Sendable {
    case acknowledged
    case retryLater
    case rejected
}

@MainActor
final class EventOutbox: EventRecording {
    private var pending: [PlaybackEvent] = []
    private var attempts: [UUID: Int] = [:]
    private(set) var droppedCount = 0

    private let capacity: Int
    private let maximumAttempts: Int

    init(capacity: Int, maximumAttempts: Int) {
        precondition(capacity > 0 && maximumAttempts > 0)
        self.capacity = capacity
        self.maximumAttempts = maximumAttempts
    }

    func enqueue(_ event: PlaybackEvent) {
        guard !pending.contains(where: { $0.id == event.id }) else { return }
        if pending.count >= capacity {
            let evicted = pending.removeFirst()
            attempts[evicted.id] = nil
            droppedCount += 1
        }
        pending.append(event)
    }

    func batch(for accountID: UUID, limit: Int) -> [PlaybackEvent] {
        guard limit > 0 else { return [] }
        return Array(pending.lazy.filter { $0.accountID == accountID }.prefix(limit))
    }

    func resolve(_ eventID: UUID, as outcome: DeliveryOutcome) {
        guard pending.contains(where: { $0.id == eventID }) else { return }
        switch outcome {
        case .acknowledged:
            remove(eventID)
        case .rejected:
            remove(eventID)
            droppedCount += 1
        case .retryLater:
            let count = attempts[eventID, default: 0] + 1
            if count >= maximumAttempts {
                remove(eventID)
                droppedCount += 1
            } else {
                attempts[eventID] = count
            }
        }
    }

    func purge(accountID: UUID) {
        let removed = pending.filter { $0.accountID == accountID }
        pending.removeAll { $0.accountID == accountID }
        for event in removed { attempts[event.id] = nil }
    }

    var oldestPendingDate: Date? { pending.first?.observedAt }

    private func remove(_ eventID: UUID) {
        pending.removeAll { $0.id == eventID }
        attempts[eventID] = nil
    }
}
