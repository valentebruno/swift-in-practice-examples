// Swift in Practice — Edition #19: SwiftData and CloudKit: Keeping Offline Edits Recoverable
// Section: Start with what the local store promises
// https://swiftinpractice.com/editions/19-swiftdata-cloudkit-offline-first/#start-with-what-the-local-store-promises

import Foundation
import SwiftData

@Model
final class PrepList {
    var recordID: UUID = UUID()
    var kitchenID: UUID = UUID()
    var serviceDay: String = ""      // yyyy-MM-dd in the kitchen’s time zone
    var shift: String = "morning"
    var createdAt: Date = Date.now
    var deletedAt: Date?
    @Relationship(deleteRule: .cascade, inverse: \PrepItem.list)
    var items: [PrepItem]? = []

    init(kitchenID: UUID, serviceDay: String, shift: String) {
        self.kitchenID = kitchenID
        self.serviceDay = serviceDay
        self.shift = shift
    }

    var logicalKey: String { "\(kitchenID)|\(serviceDay)|\(shift)" }
}

@Model
final class PrepItem {
    var itemID: UUID = UUID()
    var name: String = ""
    var quantity: Int = 0
    var editedAt: Date = Date.now
    var deletedAt: Date?
    var list: PrepList?

    init(name: String, quantity: Int) {
        self.name = name
        self.quantity = quantity
    }
}
