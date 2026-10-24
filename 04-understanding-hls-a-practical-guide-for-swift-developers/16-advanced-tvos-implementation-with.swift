// Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
// Section: Advanced tvOS Implementation with Analytics
// https://swiftinpractice.com/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#advanced-tvos-implementation-with-analytics

// Excerpt from TVVideoPlayerViewController. player, playerLayer, pipController,
// timeObserver and trackObservation are stored properties of the class.
    private func setupPictureInPicture() {
        guard let playerLayer = playerLayer,
              AVPictureInPictureController.isPictureInPictureSupported() else {
            return
        }

        // Keep a strong reference: a local controller is deallocated when this
        // method returns and Picture in Picture never starts.
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.delegate = self
    }

    private func logCurrentQuality() {
        // Track which quality variant is playing for analytics
        // Useful for understanding network conditions of your users
        guard let currentItem = player.currentItem else { return }

        if let loadedTimeRanges = currentItem.loadedTimeRanges.first {
            let timeRange = loadedTimeRanges.timeRangeValue
            let duration = CMTimeGetSeconds(timeRange.duration)
            print("Buffered: \(duration)s ahead")
        }
    }

    private func handlePlaybackProgress(_ time: CMTime) {
        // Send progress events for resume functionality
        // Critical for enterprise content (training, live events)
        let seconds = CMTimeGetSeconds(time)
        print("Playback at \(seconds)s")

        // Send to your analytics backend
        // trackPlaybackProgress(videoID: currentVideoID, position: seconds)
    }

    deinit {
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
        }
        trackObservation?.invalidate()
    }
}

// AVKit calls this delegate on the main thread; @preconcurrency states that for Swift 6.
extension TVVideoPlayerViewController: @preconcurrency AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(
        _ pictureInPictureController: AVPictureInPictureController
    ) {
        print("PiP starting")
    }
}
