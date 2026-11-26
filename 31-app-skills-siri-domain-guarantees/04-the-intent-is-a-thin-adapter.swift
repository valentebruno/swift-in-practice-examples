// Swift in Practice — Edition #31: Preserving Product Guarantees with App Skills and Siri Evaluations
// Section: The intent is a thin adapter
// https://swiftinpractice.com/editions/31-app-skills-siri-domain-guarantees/#the-intent-is-a-thin-adapter

import AppIntents

protocol AccountSession: Sendable {
    func currentAccountID() async throws -> UUID
}

struct PlaceOrderIntent: AppIntent {
    static let title: LocalizedStringResource = "Place Order"
    static let description = IntentDescription(
        "Places an order the customer has reviewed and confirmed."
    )

    @Parameter(title: "Proposal")
    var proposalID: String

    @Dependency
    var orders: OrderService

    @Dependency
    var session: any AccountSession

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let accountID = try await session.currentAccountID()
        guard let id = UUID(uuidString: proposalID) else {
            throw $proposalID.needsValueError("Which order would you like to place?")
        }

        let proposal = try await orders.proposal(id, as: accountID)
        try await requestConfirmation(
            dialog: "Place this order for \(proposal.displayTotal)?"
        )

        let receipt = try await orders.approve(
            proposalID: proposal.id, as: accountID, now: .now
        )
        let orderID = try await orders.commit(
            CommitOrderCommand(proposalID: proposal.id, approvalReceiptID: receipt.id),
            as: accountID, now: .now
        )
        return .result(dialog: "Your order is placed. Reference \(orderID.uuidString.prefix(8)).")
    }
}
