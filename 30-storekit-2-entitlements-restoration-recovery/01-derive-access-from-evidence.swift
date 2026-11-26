// Swift in Practice — Edition #30: StoreKit 2: Entitlements, Restoration, and Failure Recovery
// Section: Derive access from evidence
// https://swiftinpractice.com/editions/30-storekit-2-entitlements-restoration-recovery/#derive-access-from-evidence

import Foundation
import Observation
import StoreKit

enum Access: Equatable, Sendable {
    case checking
    case subscribed(expires: Date?, inGrace: Bool)
    case notSubscribed
}

@MainActor
@Observable
final class EntitlementStore {
    private(set) var access: Access = .checking
    private let productIDs: Set<String>
    private var updates: Task<Void, Never>?

    init(productIDs: Set<String>) {
        self.productIDs = productIDs
    }

    func start() {
        guard updates == nil else { return }
        updates = Task { [weak self] in
            for await result in Transaction.updates {
                await self?.handle(result)
            }
        }
        Task {
            for await result in Transaction.unfinished {
                await handle(result)
            }
            await refresh()
        }
    }

    func refresh() async {
        var best: Access = .notSubscribed
        var latestExpiry = Date.distantPast
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result,
                  productIDs.contains(transaction.productID),
                  transaction.revocationDate == nil else { continue }
            let expiry = transaction.expirationDate ?? .distantFuture   // nil: never expires
            guard expiry >= latestExpiry else { continue }
            latestExpiry = expiry
            let inGrace = transaction.expirationDate.map { $0 < .now } ?? false
            best = .subscribed(expires: transaction.expirationDate, inGrace: inGrace)
        }
        access = best
    }

    func handle(_ result: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = result else {
            return          // never grant from unverified evidence; log and move on
        }
        await refresh()
        await transaction.finish()
    }
}
