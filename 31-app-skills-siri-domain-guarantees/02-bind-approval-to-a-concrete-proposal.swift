// Swift in Practice — Edition #31: Preserving Product Guarantees with App Skills and Siri Evaluations
// Section: Bind approval to a concrete proposal
// https://swiftinpractice.com/editions/31-app-skills-siri-domain-guarantees/#bind-approval-to-a-concrete-proposal

import Foundation

struct CartState: Equatable, Sendable {
    var revision: Int64
    var addressRevision: Int64
    var totalMinorUnits: Int64
    var currencyCode: String
    var displayTotal: String
}

struct OrderProposal: Equatable, Sendable {
    let id: UUID
    let accountID: UUID
    let cartRevision: Int64
    let addressRevision: Int64
    let totalMinorUnits: Int64
    let currencyCode: String
    let displayTotal: String
    let expiresAt: Date
}

struct ApprovalReceipt: Equatable, Sendable {
    let id: UUID
    let proposalID: UUID
    let accountID: UUID
}

struct CommitOrderCommand: Equatable, Sendable {
    let proposalID: UUID
    let approvalReceiptID: UUID
}

enum OrderRejection: Error, Equatable {
    case cartNotFound
    case proposalNotFound
    case approvalMissing
    case proposalExpired
    case proposalChanged(current: OrderProposal)
}
