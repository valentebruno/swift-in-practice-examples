import Foundation

enum SpatialPresentation: Equatable, Sendable {
    case closed
    case opening(requestID: UUID, placeID: UUID)
    case open(sessionID: UUID, placeID: UUID)
    case closing(sessionID: UUID)
    case unavailable
}

enum OpenOutcome: Sendable {
    case opened
    case cancelled
    case failed
}

func resolveOpen(
    state: SpatialPresentation,
    requestID: UUID,
    outcome: OpenOutcome
) -> SpatialPresentation {
    guard case let .opening(currentID, placeID) = state,
          currentID == requestID else {
        return state
    }

    switch outcome {
    case .opened:
        return .open(sessionID: requestID, placeID: placeID)
    case .cancelled:
        return .closed
    case .failed:
        return .unavailable
    }
}
