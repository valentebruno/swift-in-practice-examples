// Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
// Section: Monitor Quality and Bandwidth
// https://swiftinpractice.com/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#monitor-quality-and-bandwidth

extension VideoViewController {
    private var statusObservation: NSKeyValueObservation?
    private var mediaSelectionObservation: NSKeyValueObservation?

    private func monitorPlaybackQuality() {
        // Monitor time control status
        statusObservation = player.observe(
            \.timeControlStatus,
            options: [.new]
        ) { [weak self] player, _ in
            guard let self = self else { return }
            switch player.timeControlStatus {
            case .playing:
                print("Playing - network good")
            case .paused:
                print("Paused")
            case .waitingToPlayAtSpecifiedRate:
                print("Buffering - network congestion detected")
            @unknown default:
                break
            }
        }

        // Log current quality variant
        mediaSelectionObservation = player.currentItem?.observe(
            \.preferredMediaSelection,
            options: [.new]
        ) { [weak self] item, _ in
            guard let self = self else { return }

            if let preferredMediaSelection = item.preferredMediaSelection {
                // Get visual (video) track
                if let visualGroup = item.asset.mediaSelectionGroup(
                    forMediaCharacteristic: .visual
                ) {
                    if let videoTrack = preferredMediaSelection.selectedMediaOption(
                        in: visualGroup
                    ) {
                        print("Playing video: \(videoTrack.displayName)")
                    }
                }

                // Get audible (audio) track
                if let audibleGroup = item.asset.mediaSelectionGroup(
                    forMediaCharacteristic: .audible
                ) {
                    if let audioTrack = preferredMediaSelection.selectedMediaOption(
                        in: audibleGroup
                    ) {
                        print("Playing audio: \(audioTrack.displayName)")
                    }
                }
            }
        }
    }

    func cleanupObservers() {
        statusObservation?.invalidate()
        mediaSelectionObservation?.invalidate()
    }
}
