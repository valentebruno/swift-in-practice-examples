// Swift in Practice — Edition #41: Where Your Live Stream Falls Behind
// Section: Bound the work before the encoder
// https://swiftinpractice.com/editions/41-live-streaming-beyond-avfoundation/#bound-the-work-before-the-encoder

struct CapturedFrame: @unchecked Sendable {
    let sampleBuffer: CMSampleBuffer
}

final class LatestFrameMailbox<Frame: Sendable>: Sendable {
    private let slot = Mutex<Frame?>(nil)
    private let replaced = Mutex<Int>(0)

    func offer(_ frame: Frame) {
        let hadPending = slot.withLock { pending in
            defer { pending = frame }
            return pending != nil
        }
        if hadPending {
            replaced.withLock { $0 += 1 }
        }
    }

    func take() -> Frame? {
        slot.withLock { pending in
            defer { pending = nil }
            return pending
        }
    }

    var replacedCount: Int {
        replaced.withLock { $0 }
    }
}
