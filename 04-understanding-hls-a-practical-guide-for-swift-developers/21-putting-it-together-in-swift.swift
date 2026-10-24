// Swift in Practice — Edition #4: Understanding HLS: A Practical Guide for Swift Developers
// Section: Putting It Together in Swift
// https://swiftinpractice.com/editions/4-understanding-hls-a-practical-guide-for-swift-developers/#putting-it-together-in-swift

import AVFoundation
import AVKit
import Combine

class VideoViewController: UIViewController {
    private let player = AVPlayer()
    private var playerViewController: AVPlayerViewController?
    private var cancellables = Set<AnyCancellable>()
    private var timeObserver: Any?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        setupObservers()
    }

    private func setupPlayer() {
        // Your HLS stream URL
        guard let url = URL(string: "https://example.com/stream.m3u8") else {
            showError("Invalid stream URL")
            return
        }

        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)

        // AVPlayer automatically handles variant selection based on bandwidth
        player.replaceCurrentItem(with: playerItem)

        // Allow smoother playback recovery during short stalls
        player.automaticallyWaitsToMinimizeStalling = true

        // Setup player view controller
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        playerViewController?.delegate = self

        if let controller = playerViewController {
            addChild(controller)
            view.addSubview(controller.view)
            controller.view.frame = view.bounds
            controller.didMove(toParent: self)

            player.play()
        }
    }

    private func setupObservers() {
        // Monitor playback state
        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                self?.handleTimeControlStatus(status)
            }
            .store(in: &cancellables)

        // Monitor current item
        player.publisher(for: \.currentItem)
            .sink { [weak self] item in
                self?.setupItemObservers(item)
            }
            .store(in: &cancellables)

        // Track playback progress
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] time in
            self?.handlePlaybackProgress(time)
        }
    }

    private func setupItemObservers(_ item: AVPlayerItem?) {
        guard let item = item else { return }

        // Monitor buffer status
        item.publisher(for: \.isPlaybackBufferEmpty)
            .sink { isEmpty in
                if isEmpty { print("Buffer empty - rebuffering") }
            }
            .store(in: &cancellables)

        // Monitor loaded time ranges
        item.publisher(for: \.loadedTimeRanges)
            .sink { [weak self] ranges in
                self?.handleBufferStatus(ranges)
            }
            .store(in: &cancellables)

        // Monitor stalled playback
        NotificationCenter.default.publisher(for: .AVPlayerItemPlaybackStalled)
            .sink { _ in
                print("Playback stalled - network issue detected")
            }
            .store(in: &cancellables)
    }

    private func handleTimeControlStatus(_ status: AVPlayer.TimeControlStatus) {
        switch status {
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

    private func handleBufferStatus(_ ranges: [NSValue]) {
        guard let currentTime = player.currentItem?.currentTime() else { return }

        let bufferedSeconds = ranges
            .compactMap { $0.timeRangeValue }
            .filter { $0.containsTime(currentTime) }
            .map { CMTimeGetSeconds($0.duration) }
            .reduce(0, +)

        print("Buffered \(bufferedSeconds)s ahead")
    }

    private func handlePlaybackProgress(_ time: CMTime) {
        let seconds = CMTimeGetSeconds(time)
        print("Playback progress: \(seconds)s")
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Playback Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    deinit {
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
        }
    }
}

extension VideoViewController: AVPlayerViewControllerDelegate {
    func playerViewController(
        _ playerViewController: AVPlayerViewController,
        willBeginFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator
    ) {
        print("Entering fullscreen")
    }
}
