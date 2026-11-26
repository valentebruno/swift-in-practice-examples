// Swift in Practice — Edition #31: Preserving Product Guarantees with App Skills and Siri Evaluations
// Section: The commit operation carries the guarantees
// https://swiftinpractice.com/editions/31-app-skills-siri-domain-guarantees/#the-commit-operation-carries-the-guarantees

actor OrderService {
    private var carts: [UUID: CartState] = [:]
    private var proposals: [UUID: OrderProposal] = [:]
    private var approvals: [UUID: ApprovalReceipt] = [:]
    private var orderByProposal: [UUID: UUID] = [:]
    private let proposalLifetime: TimeInterval

    init(proposalLifetime: TimeInterval = 300) {
        self.proposalLifetime = proposalLifetime
    }

    var orderCount: Int { orderByProposal.count }

    func setCart(_ cart: CartState, for accountID: UUID) {
        carts[accountID] = cart
    }

    func propose(as accountID: UUID, now: Date) throws(OrderRejection) -> OrderProposal {
        guard let cart = carts[accountID] else { throw .cartNotFound }
        let proposal = OrderProposal(
            id: UUID(),
            accountID: accountID,
            cartRevision: cart.revision,
            addressRevision: cart.addressRevision,
            totalMinorUnits: cart.totalMinorUnits,
            currencyCode: cart.currencyCode,
            displayTotal: cart.displayTotal,
            expiresAt: now.addingTimeInterval(proposalLifetime)
        )
        proposals[proposal.id] = proposal
        return proposal
    }

    func proposal(_ id: UUID, as accountID: UUID) throws(OrderRejection) -> OrderProposal {
        guard let proposal = proposals[id], proposal.accountID == accountID else {
            throw .proposalNotFound
        }
        return proposal
    }

    func approve(
        proposalID: UUID, as accountID: UUID, now: Date
    ) throws(OrderRejection) -> ApprovalReceipt {
        let proposal = try proposal(proposalID, as: accountID)
        guard now < proposal.expiresAt else { throw .proposalExpired }
        let receipt = ApprovalReceipt(
            id: UUID(), proposalID: proposal.id, accountID: accountID
        )
        approvals[receipt.id] = receipt
        return receipt
    }

    func commit(
        _ command: CommitOrderCommand, as accountID: UUID, now: Date
    ) throws(OrderRejection) -> UUID {
        let proposal = try proposal(command.proposalID, as: accountID)

        if let existingOrder = orderByProposal[proposal.id] {
            return existingOrder
        }
        guard let approval = approvals[command.approvalReceiptID],
              approval.proposalID == proposal.id,
              approval.accountID == accountID else {
            throw .approvalMissing
        }
        guard now < proposal.expiresAt else { throw .proposalExpired }

        guard let cart = carts[accountID],
              cart.revision == proposal.cartRevision,
              cart.addressRevision == proposal.addressRevision,
              cart.totalMinorUnits == proposal.totalMinorUnits,
              cart.currencyCode == proposal.currencyCode else {
            throw .proposalChanged(current: try propose(as: accountID, now: now))
        }

        let orderID = UUID()
        orderByProposal[proposal.id] = orderID
        return orderID
    }
}
