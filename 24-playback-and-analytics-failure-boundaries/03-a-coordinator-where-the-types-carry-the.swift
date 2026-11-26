// Swift in Practice — Edition #24: Should the Music Stop When Analytics Fails?
// Section: A coordinator where the types carry the policy
// https://swiftinpractice.com/editions/24-playback-and-analytics-failure-boundaries/#a-coordinator-where-the-types-carry-the-policy

import Observation

protocol EntitlementChecking: Sendable {
    func canPlay(trackID: String, accountID: UUID) async throws -> Bool
}

protocol MediaPreparing: Sendable {
    /// Prepare resources for this session without replacing the active player item.
    func prepare(trackID: String, for session: PlaybackSessionID) async throws
}

@MainActor
protocol EventRecording: Sendable {
    /// Enqueue locally with bounded work. Delivery happens elsewhere.
    func enqueue(_ event: PlaybackEvent)
}

@MainActor
@Observable
final class PlaybackCoordinator {
    private(set) var state: PlaybackState = .idle

    private let accountID: UUID
    private let entitlements: any EntitlementChecking
    private let media: any MediaPreparing
    private let events: any EventRecording

    init(
        accountID: UUID,
        entitlements: any EntitlementChecking,
        media: any MediaPreparing,
        events: any EventRecording
    ) {
        self.accountID = accountID
        self.entitlements = entitlements
        self.media = media
        self.events = events
    }

    func play(trackID: String) async {
        let session = PlaybackSessionID(rawValue: UUID())
        state = .preparing(session)
        emit(.requested, session: session, trackID: trackID)

        do {
            guard try await entitlements.canPlay(
                trackID: trackID, accountID: accountID
            ) else {
                finish(session, with: .failed(
                    session, message: "This track isn't included in your plan."
                ))
                return
            }
            guard state.sessionID == session else { return }
            try await media.prepare(trackID: trackID, for: session)
        } catch {
            finish(session, with: .failed(
                session, message: "We couldn't load this track."
            ))
            return
        }

        guard state.sessionID == session else { return }
        state = .playing(session)
        emit(.started, session: session, trackID: trackID)
    }

    private func finish(_ session: PlaybackSessionID, with newState: PlaybackState) {
        guard state.sessionID == session else { return }
        state = newState
    }

    private func emit(
        _ kind: PlaybackEvent.Kind,
        session: PlaybackSessionID,
        trackID: String
    ) {
        events.enqueue(PlaybackEvent(
            id: UUID(), accountID: accountID, sessionID: session,
            trackID: trackID, kind: kind, observedAt: Date()
        ))
    }
}
