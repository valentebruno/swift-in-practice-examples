// Swift in Practice — Edition #19: SwiftData and CloudKit: Keeping Offline Edits Recoverable
// Section: Give each record two identities
// https://swiftinpractice.com/editions/19-swiftdata-cloudkit-offline-first/#give-each-record-two-identities

import Foundation

struct PrepListRecord: Sendable {
    let logicalKey: String
    let recordID: UUID
    let createdAt: Date
}

func canonicalRecord(
    in records: [PrepListRecord], for key: String
) -> PrepListRecord? {
    records.lazy.filter { $0.logicalKey == key }.min { lhs, rhs in
        if lhs.createdAt != rhs.createdAt {
            return lhs.createdAt < rhs.createdAt
        }
        return lhs.recordID.uuidString < rhs.recordID.uuidString
    }
}
