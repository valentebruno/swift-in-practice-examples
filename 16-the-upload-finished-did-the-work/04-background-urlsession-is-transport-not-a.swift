// Swift in Practice — Edition #16: The Upload Finished. Did the Work?
// Section: Background URLSession Is Transport, Not a Workflow Engine
// https://swiftinpractice.com/editions/16-the-upload-finished-did-the-work/#background-urlsession-is-transport-not-a-workflow-engine

extension UploadCoordinator {
    func schedule(_ id: UUID, file: URL, recordID: String)
        throws {
        // Headers are frozen until the transfer runs:
        // prefer a short-lived, pre-authorized upload URL.
        var request = URLRequest(
            url: try Endpoints.uploadURL(recordID: recordID))
        request.httpMethod = "PUT"
        request.setValue(id.uuidString,
                         forHTTPHeaderField: "Idempotency-Key")

        let task = session.uploadTask(with: request,
                                      fromFile: file)
        task.taskDescription = id.uuidString
        try ledger.update(id, state: .uploading)
        task.resume()
    }
}
