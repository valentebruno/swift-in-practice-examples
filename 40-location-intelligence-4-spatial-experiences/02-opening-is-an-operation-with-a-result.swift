// Swift in Practice — Edition #40: From Maps to Spatial Experiences
// Section: Opening is an operation with a result
// https://swiftinpractice.com/editions/40-location-intelligence-4-spatial-experiences/#opening-is-an-operation-with-a-result

import Foundation
import Observation

enum SpatialPresentation: Equatable, Sendable {
    case closed
    case opening(requestID: UUID, placeID: UUID)
    case open(sessionID: UUID, placeID: UUID)
    case closing(sessionID: UUID)
    case unavailable

    var placeID: UUID? {
        switch self {
        case .opening(_, let placeID), .open(_, let placeID): placeID
        case .closed, .closing, .unavailable: nil
        }
    }
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
