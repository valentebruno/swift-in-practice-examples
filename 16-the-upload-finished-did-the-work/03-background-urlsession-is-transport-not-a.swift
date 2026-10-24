// Swift in Practice — Edition #16: The Upload Finished. Did the Work?
// Section: Background URLSession Is Transport, Not a Workflow Engine
// https://swiftinpractice.com/editions/16-the-upload-finished-did-the-work/#background-urlsession-is-transport-not-a-workflow-engine

actor UploadCoordinator {
    private let ledger: UploadLedger    // durable store
    private let session: URLSession     // background config

    func enqueue(_ source: URL, recordID: String)
        throws -> UUID {
        let id = UUID()
        let file = try FileStore.url(for: id)

        // 1. A durable local copy, readable after first unlock,
        //    so the system can upload while the phone is locked.
        try FileManager.default.copyItem(at: source, to: file)
        try FileManager.default.setAttributes(
            [.protectionKey: FileProtectionType
                .completeUntilFirstUserAuthentication],
            ofItemAtPath: file.path)

        // 2. Durable intent, recorded before any network work.
        try ledger.insert(id, recordID: recordID,
                          file: file, state: .queued)

        // 3. Transport. Background uploads must come from a file.
        try schedule(id, file: file, recordID: recordID)
        return id
    }
}
