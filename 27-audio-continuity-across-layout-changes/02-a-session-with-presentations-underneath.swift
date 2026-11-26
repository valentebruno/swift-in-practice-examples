// Swift in Practice — Edition #27: A Fold Shouldn’t Restart Playback
// Section: A session with presentations underneath it
// https://swiftinpractice.com/editions/27-audio-continuity-across-layout-changes/#a-session-with-presentations-underneath-it

import Observation

@MainActor
@Observable
final class PlaybackSession {
    private let player: AVPlayer

    private(set) var currentTrackID: String?
    private(set) var userWantsPlayback = false
    private(set) var isInterrupted = false
    private(set) var itemReplacementCount = 0
    private(set) var expression = PlaybackSession.neutralExpression

    static let neutralExpression = 0.5

    init(player: AVPlayer = AVPlayer()) {
        self.player = player
    }

    func load(trackID: String, url: URL) {
        guard trackID != currentTrackID else { return }
        currentTrackID = trackID
        itemReplacementCount += 1
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        if userWantsPlayback, !isInterrupted { player.play() }
    }

    func play() {
        userWantsPlayback = true
        if !isInterrupted { player.play() }
    }

    func pause() {
        userWantsPlayback = false
        player.pause()
    }

    func interruptionBegan() {
        isInterrupted = true
    }

    func interruptionEnded(shouldResume: Bool) {
        isInterrupted = false
        if shouldResume, userWantsPlayback { player.play() }
    }

    func setExpression(_ value: Double?) {
        expression = value.map { min(max($0, 0), 1) } ?? Self.neutralExpression
    }
}
