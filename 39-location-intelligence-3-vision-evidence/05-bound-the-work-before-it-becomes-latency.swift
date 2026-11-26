// Swift in Practice — Edition #39: From Camera Frame to Map Pin
// Section: Bound the work before it becomes latency
// https://swiftinpractice.com/editions/39-location-intelligence-3-vision-evidence/#bound-the-work-before-it-becomes-latency

actor LatestFrameProcessor<Frame: Sendable, Output: Sendable> {
    private let infer: @Sendable (Frame) async -> Output
    private let deliver: @Sendable (Output, _ sessionID: UInt64) async -> Void

    private var pending: (frame: Frame, sessionID: UInt64)?
    private var isRunning = false
    private(set) var droppedFrameCount = 0

    init(
        infer: @escaping @Sendable (Frame) async -> Output,
        deliver: @escaping @Sendable (Output, _ sessionID: UInt64) async -> Void
    ) {
        self.infer = infer
        self.deliver = deliver
    }

    func submit(_ frame: Frame, sessionID: UInt64) {
        if pending != nil { droppedFrameCount += 1 }
        pending = (frame, sessionID)

        guard !isRunning else { return }
        isRunning = true
        Task { await drain() }
    }

    private func drain() async {
        while let next = pending {
            pending = nil
            let output = await infer(next.frame)
            await deliver(output, next.sessionID)
        }
        isRunning = false
    }
}
