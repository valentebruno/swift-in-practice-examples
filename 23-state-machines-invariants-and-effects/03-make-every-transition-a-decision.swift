// Swift in Practice — Edition #23: Your App Has More States Than Your Model Admits
// Section: Make every transition a decision
// https://swiftinpractice.com/editions/23-state-machines-invariants-and-effects/#make-every-transition-a-decision

func reduce(
    _ state: UploadState,
    _ event: UploadEvent
) -> UploadState {
    switch (state, event) {
    case (.idle, let .start(attempt)),
         (.failed, let .start(attempt)),
         (.cancelled, let .start(attempt)):
        return .uploading(attempt: attempt)

    case let (.uploading(current), .transferred(attempt, remoteID))
        where current == attempt:
        return .verifying(attempt: attempt, remoteID: remoteID)

    case let (.verifying(current, expectedID),
              .verified(attempt, remoteID))
        where current == attempt && expectedID == remoteID:
        return .succeeded(remoteID: remoteID)

    case let (.uploading(current), .failed(attempt, reason))
        where current == attempt:
        return .failed(attempt: attempt, reason: reason)

    case let (.verifying(current, _), .failed(attempt, reason))
        where current == attempt:
        return .failed(attempt: attempt, reason: reason)

    case let (.uploading(current), .cancel(attempt))
        where current == attempt:
        return .cancelled(attempt: attempt)

    case let (.verifying(current, _), .cancel(attempt))
        where current == attempt:
        return .cancelled(attempt: attempt)

    default:
        return state
    }
}
