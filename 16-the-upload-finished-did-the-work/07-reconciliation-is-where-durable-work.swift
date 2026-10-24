// Swift in Practice — Edition #16: The Upload Finished. Did the Work?
// Section: Reconciliation Is Where Durable Work Finishes
// https://swiftinpractice.com/editions/16-the-upload-finished-did-the-work/#reconciliation-is-where-durable-work-finishes

extension UploadCoordinator {
    func reconcile() async throws {
        let inFlight = await session.allTasks
        let live = Set(inFlight.compactMap(\.taskDescription))

        // Skip anything the system still owns.
        for item in try ledger.pending()
            where !live.contains(item.id.uuidString) {
            do {
                // Nothing in flight: ask the authority.
                switch try await api.status(of: item.id) {
                case .committed(let remoteID):
                    try ledger.update(item.id,
                        state: .committed(remoteID: remoteID))
                case .received:
                    // Bytes arrived, the commit never did.
                    try ledger.update(item.id,
                        state: .awaitingCommit)
                    let remoteID = try await api.finalize(item.id)
                    try ledger.update(item.id,
                        state: .committed(remoteID: remoteID))
                case .unknown:
                    // Same operation ID. Never a new one.
                    try schedule(item.id, file: item.file,
                                 recordID: item.recordID)
                }
            } catch is URLError {
                continue   // Offline is transient. Retry later.
            } catch {
                // One poisoned item must not stall the rest.
                try ledger.update(item.id, state: .needsAttention(
                    reason: error.localizedDescription))
            }
        }
    }
}
