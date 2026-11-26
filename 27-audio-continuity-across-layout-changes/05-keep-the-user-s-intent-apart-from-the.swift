// Swift in Practice — Edition #27: A Fold Shouldn’t Restart Playback
// Section: Keep the user's intent apart from the system's permission
// https://swiftinpractice.com/editions/27-audio-continuity-across-layout-changes/#keep-the-user-s-intent-apart-from-the-system-s-permission

@available(iOS 27.0, *)
@MainActor
final class AudioSessionAdapter {
    private let session: PlaybackSession
    private var observers: [any NSObjectProtocol] = []

    init(session: PlaybackSession) {
        self.session = session
        let center = NotificationCenter.default
        let audioSession = AVAudioSession.sharedInstance()

        observers.append(center.addObserver(
            forName: AVAudioSession.didBecomeInactiveNotification,
            object: audioSession, queue: .main
        ) { [weak self] notification in
            let context = notification.userInfo?[AVAudioSession.deactivationContextKey]
                as? AVAudioSession.DeactivationContext
            MainActor.assumeIsolated {
                guard context?.source == .system else { return }
                self?.session.interruptionBegan()
            }
        })

        observers.append(center.addObserver(
            forName: AVAudioSession.resumptionRecommendationNotification,
            object: audioSession, queue: .main
        ) { [weak self] notification in
            let context = notification.userInfo?[AVAudioSession.resumptionContextKey]
                as? AVAudioSession.ResumptionContext
            MainActor.assumeIsolated {
                self?.session.interruptionEnded(
                    shouldResume: context?.recommendation == .shouldResume
                )
            }
        })
    }
}
