// Swift in Practice — Edition #23: Your App Has More States Than Your Model Admits
// Section: Effects: who does the work
// https://swiftinpractice.com/editions/23-state-machines-invariants-and-effects/#effects-who-does-the-work

enum UploadEffect: Equatable, Sendable {
    case startTransfer(attempt: UUID)
    case startVerification(attempt: UUID, remoteID: String)
    case cancelWork(attempt: UUID)
}

func step(
    _ state: UploadState,
    _ event: UploadEvent
) -> (state: UploadState, effects: [UploadEffect]) {
    let next = reduce(state, event)
    guard next != state else { return (state, []) }

    switch next {
    case .uploading(let attempt):
        return (next, [.startTransfer(attempt: attempt)])
    case .verifying(let attempt, let remoteID):
        return (next, [.startVerification(attempt: attempt, remoteID: remoteID)])
    case .cancelled(let attempt):
        return (next, [.cancelWork(attempt: attempt)])
    case .failed(let attempt, _):
        return (next, [.cancelWork(attempt: attempt)])
    case .idle, .succeeded:
        return (next, [])
    }
}
