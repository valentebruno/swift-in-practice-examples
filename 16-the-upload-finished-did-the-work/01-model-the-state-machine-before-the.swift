// Swift in Practice — Edition #16: The Upload Finished. Did the Work?
// Section: Model the State Machine Before the Transfer
// https://swiftinpractice.com/editions/16-the-upload-finished-did-the-work/#model-the-state-machine-before-the-transfer

enum AttachmentState: Equatable, Codable {
    case queued
    case uploading
    case awaitingVerification
    case awaitingCommit
    case committed(remoteID: String)
    case needsAttention(reason: String)
}
