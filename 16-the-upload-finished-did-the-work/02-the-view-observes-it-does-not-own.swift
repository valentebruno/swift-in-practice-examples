// Swift in Practice — Edition #16: The Upload Finished. Did the Work?
// Section: The View Observes. It Does Not Own.
// https://swiftinpractice.com/editions/16-the-upload-finished-did-the-work/#the-view-observes-it-does-not-own

struct AttachmentRow: View {
    let attachmentID: UUID
    let coordinator: UploadCoordinator
    @State private var state: AttachmentState = .queued

    var body: some View {
        StatusLabel(state: state)
            .task(id: attachmentID) {
                // Cancelled when the row disappears.
                // The observation stops. The upload does not.
                let updates = await coordinator
                    .states(for: attachmentID)
                for await update in updates {
                    state = update
                }
            }
    }
}
