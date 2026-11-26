// Swift in Practice — Edition #30: StoreKit 2: Entitlements, Restoration, and Failure Recovery
// Section: Finish after delivery, never before
// https://swiftinpractice.com/editions/30-storekit-2-entitlements-restoration-recovery/#finish-after-delivery-never-before

actor CreditLedger {
    private var processed: Set<UInt64> = []
    private(set) var balance = 0

    /// Credits the transaction once. Returns the balance either way.
    func credit(transactionID: UInt64, amount: Int) -> Int {
        if processed.insert(transactionID).inserted {
            balance += amount
        }
        return balance
    }
}

func deliverCredits(
    _ result: VerificationResult<Transaction>,
    ledger: CreditLedger,
    amount: Int
) async throws {
    let transaction = try result.payloadValue
    _ = await ledger.credit(transactionID: transaction.id, amount: amount)
    await transaction.finish()
}
