// Swift in Practice — Edition #11: Building Real-Time Computer Vision Pipelines in Swift
// Section: Phone calls. Control Center. Picture-in-Picture. FaceTime. Notification Center. Screen recording.
// https://swiftinpractice.com/editions/11-building-real-time-computer-vision-pipelines-in-swift/#phone-calls-control-center-picture-in-picture-facetime-notif

private var captureSessionRunningObserver: NSKeyValueObservation?

func setupSessionMonitoring() {
    captureSessionRunningObserver = captureSession.observe(
        \.isRunning,
        options: [.new]
    ) { [weak self] session, change in
        guard let self = self else { return }

        if change.newValue == false {
            self.handleSessionStopped()
        } else {
            self.handleSessionStarted()
        }
    }
}

deinit {
    captureSessionRunningObserver?.invalidate()
}
