import Foundation

struct FlightSnapshot: Equatable, Sendable {
    let accountID: UUID
    let flightID: UUID
    let epoch: UUID
    let revision: UInt64
    let status: Status

    enum Status: String, Sendable {
        case confirmed, delayed, cancelled
    }
}

enum Acceptance: Equatable, Sendable {
    case applied, duplicate, stale, wrongScope, conflictingRevision
}

actor FlightStore {
    private let accountID: UUID
    private let flightID: UUID
    private let epoch: UUID
    private var current: FlightSnapshot?

    init(accountID: UUID, flightID: UUID, epoch: UUID) {
        self.accountID = accountID
        self.flightID = flightID
        self.epoch = epoch
    }

    func apply(_ incoming: FlightSnapshot) -> Acceptance {
        guard incoming.accountID == accountID,
              incoming.flightID == flightID,
              incoming.epoch == epoch else { return .wrongScope }

        if let current {
            guard incoming.revision >= current.revision else {
                return .stale
            }
            if incoming.revision == current.revision {
                return incoming == current ? .duplicate : .conflictingRevision
            }
        }

        current = incoming
        return .applied
    }

    func snapshot() -> FlightSnapshot? { current }
}
