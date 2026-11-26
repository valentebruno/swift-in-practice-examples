// Swift in Practice — Edition #30: StoreKit 2: Entitlements, Restoration, and Failure Recovery
// Section: Let pending, grace, and restore look different
// https://swiftinpractice.com/editions/30-storekit-2-entitlements-restoration-recovery/#let-pending-grace-and-restore-look-different

func buy(_ product: Product, store: EntitlementStore) async throws -> String {
    switch try await product.purchase() {
    case .success(let verification):
        guard await store.handle(verification) else {
            return "We couldn’t verify access for this purchase."
        }
        return "Purchase complete."
    case .pending:
        return "Waiting for approval. You’ll get access as soon as it’s approved."
    case .userCancelled:
        return ""
    @unknown default:
        return ""
    }
}
