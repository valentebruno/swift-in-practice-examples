// Swift in Practice — Edition #19: SwiftData and CloudKit: Keeping Offline Edits Recoverable
// Section: Merge the work, then retire the copy
// https://swiftinpractice.com/editions/19-swiftdata-cloudkit-offline-first/#merge-the-work-then-retire-the-copy

import Foundation

struct ItemState: Equatable, Sendable {
    let itemID: UUID
    var name: String
    var quantity: Int
    var editedAt: Date
    var deletedAt: Date?
}

enum MergeOutcome: Equatable, Sendable {
    case merged(ItemState)
    case conflict(ItemState, ItemState)
}

func merge(_ a: ItemState, _ b: ItemState) -> MergeOutcome {
    precondition(a.itemID == b.itemID)
    switch (a.deletedAt, b.deletedAt) {
    case let (deleted?, nil) where b.editedAt > deleted:
        return .conflict(a, b)          // edited after it was deleted: the chef decides
    case let (nil, deleted?) where a.editedAt > deleted:
        return .conflict(b, a)
    case let (first?, second?):
        return .merged(first <= second ? a : b)   // both deleted: every device keeps the earlier deletion
    case (_?, nil):
        return .merged(a)
    case (nil, _?):
        return .merged(b)
    case (nil, nil):
        break
    }
    guard a.name != b.name || a.quantity != b.quantity else {
        return .merged(a.editedAt >= b.editedAt ? a : b)
    }
    if a.editedAt == b.editedAt { return .conflict(a, b) }
    return .merged(a.editedAt > b.editedAt ? a : b)
}
