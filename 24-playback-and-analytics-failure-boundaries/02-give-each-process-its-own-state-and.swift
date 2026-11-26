// Swift in Practice — Edition #24: Should the Music Stop When Analytics Fails?
// Section: Give each process its own state and identity
// https://swiftinpractice.com/editions/24-playback-and-analytics-failure-boundaries/#give-each-process-its-own-state-and-identity

struct PlaybackSessionID: Hashable, Codable, Sendable {
    let rawValue: UUID
}

struct PlaybackEvent: Codable, Equatable, Sendable {
    enum Kind: String, Codable, Sendable {
        case requested, started, completed
    }

    let id: UUID
    let accountID: UUID
    let sessionID: PlaybackSessionID
    let trackID: String
    let kind: Kind
    let observedAt: Date
}

enum PlaybackState: Equatable, Sendable {
    case idle
    case preparing(PlaybackSessionID)
    case playing(PlaybackSessionID)
    case interrupted(PlaybackSessionID)
    case failed(PlaybackSessionID, message: String)

    var sessionID: PlaybackSessionID? {
        switch self {
        case .idle: nil
        case .preparing(let id), .playing(let id),
             .interrupted(let id), .failed(let id, _): id
        }
    }
}
